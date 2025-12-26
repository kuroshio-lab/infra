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
3. **Configure Variables & Secrets**:
   Create a `personal.tfvars` file in `terraform/shared/` to provide values for input variables, especially sensitive ones. Refer to `terraform/shared/dns/variables.tf` and `terraform/shared/variables.tf` for required variables.
   **IMPORTANT**: Ensure `personal.tfvars` is added to your `.gitignore` and *never* committed to the repository. For an example of the variables needed, you can check `terraform/shared/personal.tfvars.example` (if you create one with dummy values).
4. **Deploy shared infrastructure**:

```bash
cd terraform/shared
terraform init
terraform apply -var-file="personal.tfvars
```

5. **Configure domain nameservers** with output from `terraform output name_servers`

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


### 2. Configure Local Variables and Secrets

Before running `terraform init` and `apply`, you need to set up your local configuration variables, especially for sensitive data.

1.  **Review Required Variables**:
    *   Examine `terraform/shared/variables.tf` for global variables.
    *   Examine `terraform/shared/dns/variables.tf` for DNS-specific variables.
    These files define what inputs your Terraform configuration expects.

2.  **Create Your Personal Variables File**:
    In the `terraform/shared/` directory, create a new file named `personal.tfvars` (or any `.tfvars` file name you prefer, but `personal.tfvars` is a common convention). This file will contain the actual values for the variables, including any sensitive information.


    # terraform/shared/personal.tfvars
    # This file should NEVER be committed to Git! Add it to your .gitignore.

    aws_region = "eu-west-3" # Example: your desired AWS region
    domain_name = "kuroshio-lab.com" # Example: your domain name
    environment = "production" # Example: your environment

    # Sensitive variables for the DNS module (defined in terraform/shared/variables.tf)
    google_site_verification_token_for_dns = "YOUR_GOOGLE_SITE_VERIFICATION_TOKEN"
    resend_dkim_public_key_for_dns       = "YOUR_RESEND_DKIM_PUBLIC_KEY"
    acm_validation_cname_name_for_dns    = "YOUR_ACM_VALIDATION_CNAME_NAME"
    acm_validation_cname_value_for_dns   = "YOUR_ACM_VALIDATION_CNAME_VALUE"
        *Replace the placeholder values with your actual credentials/tokens.*

3.  **Add to `.gitignore`**:
    Ensure your `personal.tfvars` file (or any file containing secrets) is added to your `.gitignore` file to prevent accidental commitment to version control.


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
