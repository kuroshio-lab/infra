# 🌊 Kuroshio-Lab Infrastructure

Global infrastructure repository for the Kuroshio-Lab platform - a unified ecosystem of open-source tools for ocean preservation and marine biology.

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)

---

## 📋 Overview

This repository manages the **shared infrastructure** that supports all five Kuroshio-Lab applications:

- 🐚 **Species Tracker** - Marine species observation logging
- 🌊 **Ocean Dashboard** - Oceanographic data analytics
- 🪸 **Reef Health** - Coral reef monitoring & ML
- 🐠 **Encyclopedia** - Marine life knowledge base
- 🛰️ **Monitoring** - Environmental data ingestion

Each application runs independently with its own database and compute resources, but shares DNS, storage, and IAM configuration managed by this repository.

---

## 🏗️ Architecture

```
kuroshio-lab.com
├── species.kuroshio-lab.com      → Species Tracker
├── dashboard.kuroshio-lab.com    → Ocean Dashboard
├── reef.kuroshio-lab.com         → Reef Health Index
├── encyclopedia.kuroshio-lab.com → Marine Encyclopedia
└── monitoring.kuroshio-lab.com   → Monitoring Platform

Each with corresponding API subdomain:
api.{app}.kuroshio-lab.com
```

### Shared Resources (This Repo)

- **Route53** - DNS management for all subdomains
- **S3** - Single bucket with prefix-based isolation (`marinex-assets/{app}/`)
- **IAM** - Application-specific roles with scoped S3 access
- **CloudWatch** - Centralized monitoring and cost alerts

### Per-Application Resources (App Repos)

Each application maintains its own:
- RDS/Aurora database
- ECS/Lambda compute
- Application Load Balancer
- App-specific monitoring

---

## 📁 Repository Structure

```
infra/
├── terraform/
│   ├── backend.tf              # Terraform state configuration
│   └── shared/
│       ├── main.tf             # AWS provider setup
│       ├── variables.tf        # Configuration variables
│       ├── outputs.tf          # Exported values for apps
│       ├── dns/                # Route53 hosted zone & records
│       ├── s3/                 # Shared bucket with lifecycle
│       ├── iam/                # Cross-app IAM roles
│       └── monitoring/         # CloudWatch alarms
├── scripts/
│   └── cost-check.sh           # AWS cost monitoring script
└── docs/
    ├── GETTING_STARTED.md      # Setup instructions
    └── TERRAFORM_BASICS.md     # Terraform primer for beginners
```

---

## 🚀 Quick Start

### Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- AWS account with admin access
- Domain registered (or ready to register)

### 1. Configure AWS Credentials

```bash
aws configure
# Enter your Access Key ID, Secret Access Key, and region (eu-west-3)
```

### 2. Create Terraform State Backend

**ONE TIME ONLY** - Creates S3 bucket and DynamoDB table for state management:

```bash
# Create S3 bucket for state
aws s3 mb s3://kuroshio-lab-terraform-state --region eu-west-3

# Enable versioning
aws s3api put-bucket-versioning --bucket kuroshio-lab-terraform-state --versioning-configuration Status=Enabled --region eu-west-3

# Create DynamoDB table for state locking
aws dynamodb create-table --table-name terraform-state-lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region eu-west-3
```

### 3. Deploy Shared Infrastructure

```bash
cd terraform/shared

# Initialize Terraform (downloads AWS provider)
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply
# Type 'yes' when prompted
```

### 4. Configure Domain Nameservers

After `terraform apply` completes, get your Route53 nameservers:

```bash
terraform output name_servers
```

Update your domain registrar with these nameservers for `kuroshio-lab.com`.

**Note:** DNS propagation takes 1-48 hours (typically ~1 hour).

---

## 💰 Cost Estimate

### Shared Infrastructure (This Repo)

| Service | Usage | Monthly Cost |
|---------|-------|--------------|
| Route53 | 1 hosted zone + 10 records | ~$0.50 |
| S3 | Storage + requests (low volume) | ~$1-5 |
| CloudWatch | Basic metrics + alarms | ~$1-2 |
| DynamoDB | State locking (minimal reads) | ~$0-1 |
| **Total** | | **~$5-10/month** |

### Per-Application Costs

Each of the 5 applications will add approximately:

- **Database** (RDS t4g.micro): ~$12-15/month
- **Compute** (Lambda or Fargate Spot): ~$5-15/month
- **Load Balancer** (ALB): ~$16/month
- **Misc** (CloudWatch Logs, data transfer): ~$2-5/month

**Estimated per app:** $35-50/month
**Total platform (5 apps):** ~$180-260/month

> **Cost Optimization Tips:**
> - Use Lambda for low-traffic apps (~$0-5/month)
> - Use Fargate Spot for 70% savings on containers
> - Consider Aurora Serverless v2 (scales to zero)
> - Implement S3 lifecycle policies (included)

---

## 🔧 Common Operations

### View Current Infrastructure

```bash
cd terraform/shared
terraform show
```

### Check Outputs (Bucket Names, Role ARNs, etc.)

```bash
terraform output
```

### Update DNS Records

Edit `terraform/shared/dns/route53.tf`, then:

```bash
terraform plan   # Preview changes
terraform apply  # Apply changes
```

### Monitor AWS Costs

```bash
./scripts/cost-check.sh

# Or get detailed breakdown
aws ce get-cost-and-usage \
  --time-period Start=2025-01-01,End=2025-01-31 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=SERVICE
```

### Format Terraform Code

```bash
terraform fmt -recursive
```

---

## 🔗 How Applications Use Shared Infrastructure

Each application repository references this shared infrastructure using Terraform remote state:

```hcl
# In species-tracker/infra/data.tf
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "kuroshio-lab-terraform-state"
    key    = "shared/terraform.tfstate"
    region = "eu-west-3"
  }
}

# Reference shared resources
resource "aws_s3_bucket_policy" "app_access" {
  bucket = data.terraform_remote_state.shared.outputs.s3_bucket_name
  # ... policy configuration
}
```

---

## 📚 Documentation

- **[Getting Started](docs/GETTING_STARTED.md)** - Detailed setup instructions
- **[Terraform Basics](docs/TERRAFORM_BASICS.md)** - Introduction to Terraform for beginners

---

## 🛡️ Security

- All S3 buckets have encryption at rest enabled (AES256)
- IAM roles follow principle of least privilege (scoped to app prefixes)
- Terraform state stored in S3 with versioning and DynamoDB locking
- Public access blocked on all S3 buckets by default
- CloudWatch alarms for cost monitoring

**Never commit:**
- AWS credentials
- `.tfstate` files (stored in S3)
- `.tfvars` files with secrets

---

## 🔄 Deployment Workflow

```
┌─────────────────────────────────────────────────────┐
│  1. Shared Infrastructure (This Repo)               │
│     • Route53, S3, IAM, CloudWatch                  │
│     • Deploy ONCE, rarely updated                   │
└─────────────────────────────────────────────────────┘
                        ↓
        ┌───────────────┴───────────────┐
        ↓                               ↓
┌──────────────────┐           ┌──────────────────┐
│  App 1: Species  │    ...    │  App 5: Monitor  │
│  • RDS           │           │  • RDS           │
│  • ECS/Lambda    │           │  • ECS/Lambda    │
│  • ALB           │           │  • ALB           │
└──────────────────┘           └──────────────────┘
```

1. **This repo** provisions shared infrastructure
2. **Each app repo** provisions its own compute/database
3. Apps deploy independently without affecting others

---

## 🚨 Troubleshooting

### "Error: Backend initialization required"

```bash
cd terraform/shared
terraform init
```

### "Error: Bucket name already exists"

S3 bucket names are globally unique. Change the bucket name in `terraform/shared/s3/bucket.tf`:

```hcl
resource "aws_s3_bucket" "shared_assets" {
  bucket = "marinex-assets-YOUR-UNIQUE-SUFFIX"  # Change this
}
```

### "Error: No credentials found"

```bash
aws configure
# Or check current credentials:
aws sts get-caller-identity
```

### "Error: Access Denied"

Ensure your IAM user has `AdministratorAccess` or equivalent permissions.

---

## 🤝 Contributing

This is the foundational infrastructure for Kuroshio-Lab. Changes should be:

1. Discussed via issues first
2. Tested with `terraform plan`
3. Documented in commit messages
4. Coordinated with application teams (DNS/IAM changes affect apps)

---

## 🌊 Philosophy

Kuroshio-Lab is built on principles of:

- **Transparency** - All infrastructure is code, auditable and open
- **Modularity** - Apps are independent, reducing blast radius
- **Sustainability** - Cost-optimized architecture for long-term operation
- **Accessibility** - Documentation-first approach for contributors

Named after the Kuroshio Current, symbolizing the continuous flow of knowledge across marine ecosystems.

---

## 📞 Support

- **Documentation:** See `docs/` folder
- **Issues:** Open an issue in this repository
- **Questions:** Check Terraform docs or AWS documentation

---

**Built with 🌊 for ocean preservation**
