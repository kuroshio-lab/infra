# Kuroshio-Lab Infrastructure

Global infrastructure repository for the Kuroshio-Lab platform.

## Repository Structure

```
infra/
├── terraform/
│   ├── backend.tf              # Terraform state configuration
│   └── shared/
│       ├── main.tf             # Provider configuration
│       ├── variables.tf        # Input variables
│       ├── outputs.tf          # Exported values
│       ├── dns/                # Route53 configuration
│       ├── s3/                 # Shared storage
│       ├── iam/                # Cross-app IAM roles
│       └── monitoring/         # CloudWatch alerts
├── scripts/
│   └── cost-check.sh           # AWS cost monitoring
└── docs/
    ├── GETTING_STARTED.md      # Setup instructions
    └── TERRAFORM_BASICS.md     # Terraform primer
```

## Quick Start

1. **Prerequisites**: AWS CLI + Terraform installed
2. **Setup state backend** (see docs/GETTING_STARTED.md)
3. **Deploy shared infrastructure**:

```bash
cd terraform/shared
terraform init
terraform apply
```

4. **Configure domain nameservers** with output from `terraform output name_servers`

## What This Deploys

- Route53 hosted zone for `kuroshio-lab.com`
- S3 bucket `marinex-assets` with app-specific prefixes
- IAM roles for all 5 applications
- CloudWatch cost monitoring alerts

## Cost Estimate

- Route53: ~$2.50/month
- S3: ~$1-5/month
- CloudWatch: ~$1-2/month

**Total: ~$5-10/month**

## Documentation

- [Getting Started Guide](docs/GETTING_STARTED.md)
- [Terraform Basics](docs/TERRAFORM_BASICS.md)

## Architecture

Each application maintains its own infrastructure in `{app}/infra/`:
- Database (RDS)
- Compute (ECS/Lambda)
- App-specific DNS records
- Storage policies

Applications reference this shared infrastructure using Terraform remote state.

## Support

For questions about infrastructure setup, see the docs/ folder or open an issue.
