# Kuroshio-Lab Infrastructure - Getting Started

## Prerequisites

1. **AWS Account** with admin access
2. **AWS CLI** installed and configured (`aws configure`)
3. **Terraform** installed (https://www.terraform.io/downloads)

## First-Time Setup

### 1. Create Terraform State Backend (ONE TIME ONLY)

Before running Terraform, you need to create the S3 bucket that stores Terraform state:

```bash
# Create the state bucket
aws s3 mb s3://kuroshio-lab-terraform-state --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket kuroshio-lab-terraform-state \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 2. Initialize Terraform

```bash
cd terraform/shared
terraform init
```

This downloads AWS provider and sets up the backend.

### 3. Review the Plan

```bash
terraform plan
```

This shows what Terraform will create. Review carefully!

### 4. Apply Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

### 5. Configure Your Domain

After apply completes, you'll see name servers in the output:

```bash
terraform output name_servers
```

Go to your domain registrar (Namecheap, GoDaddy, etc.) and update the nameservers for `kuroshio-lab.com` to the values shown.

## Daily Workflow

### Check Current Infrastructure

```bash
terraform show
```

### Make Changes

1. Edit `.tf` files
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to execute

### Destroy Everything (DANGEROUS)

```bash
terraform destroy
```

Only use in emergencies or when shutting down the project.

## Cost Monitoring

```bash
# Check current month spending
./scripts/cost-check.sh

# Get detailed cost breakdown
aws ce get-cost-and-usage \
  --time-period Start=2025-01-01,End=2025-01-31 \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=SERVICE
```

## Next Steps

After shared infrastructure is deployed:

1. Each app repo will have its own `infra/` folder
2. Apps reference this shared state using `data.terraform_remote_state`
3. Deploy apps independently

## Troubleshooting

**"Error: Failed to get existing workspaces"**
- Run `terraform init` first

**"Error: Bucket already exists"**
- Change bucket name in `s3/bucket.tf`

**"Error: Access Denied"**
- Check AWS credentials: `aws sts get-caller-identity`
