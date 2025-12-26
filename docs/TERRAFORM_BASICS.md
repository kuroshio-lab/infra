# Terraform Basics for Kuroshio-Lab

## What is Terraform?

Terraform is **Infrastructure as Code** (IaC). Instead of clicking in AWS Console, you write configuration files that describe your infrastructure, and Terraform creates it.

### Key Concepts

#### 1. Resources

A resource is something you want to create in AWS:

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"
}
```

- `aws_s3_bucket` = resource type
- `my_bucket` = local name (used to reference it in other code)
- Everything inside `{}` = configuration

#### 2. Variables

Variables make your code reusable:

```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

# Use it:
provider "aws" {
  region = var.region
}
```

#### 3. Outputs

Outputs expose values for other Terraform configs or for you to see:

```hcl
output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}
```

#### 4. State

Terraform keeps track of what it created in a **state file**. This is stored in S3 (configured in `backend.tf`).

**Never edit state files manually!**

## Common Terraform Commands

```bash
# Initialize (run once per directory)
terraform init

# Format code nicely
terraform fmt

# Validate syntax
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# List all resources
terraform state list

# Destroy everything (DANGEROUS)
terraform destroy
```

## Terraform Workflow

```
1. Write .tf files
2. terraform init (first time only)
3. terraform plan (review changes)
4. terraform apply (create resources)
5. Make changes to .tf files
6. terraform plan (see what changed)
7. terraform apply (update resources)
```

## Reading Terraform Files

### Example: S3 Bucket

```hcl
resource "aws_s3_bucket" "shared_assets" {
  bucket = "marinex-assets"
  
  tags = {
    Name = "marinex-assets"
  }
}
```

**Translation:** "Create an S3 bucket named 'marinex-assets' and tag it with Name='marinex-assets'"

### Example: IAM Role

```hcl
resource "aws_iam_role" "app_role" {
  name = "my-app-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}
```

**Translation:** "Create an IAM role that ECS tasks can assume"

## How Apps Reference Shared Infrastructure

In `species-tracker/infra/data.tf`:

```hcl
data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "kuroshio-lab-terraform-state"
    key    = "shared/terraform.tfstate"
  }
}

# Now use shared outputs:
output "bucket_name" {
  value = data.terraform_remote_state.shared.outputs.s3_bucket_name
}
```

This pulls values from the shared infrastructure without duplicating code.

## Best Practices

1. **Always run `terraform plan` before `apply`**
2. **Never commit `.tfstate` files to git** (they're in S3)
3. **Use `terraform fmt` before committing**
4. **Comment complex resources**
5. **Use consistent naming:** `kuroshio-lab-{app}-{resource}`

## Learning Resources

- [Official Terraform Tutorial](https://learn.hashicorp.com/terraform)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## Common Errors and Fixes

**Error: "Provider configuration not present"**
```bash
terraform init
```

**Error: "Resource already exists"**
```bash
# Import existing resource
terraform import aws_s3_bucket.my_bucket my-bucket-name
```

**Error: "Backend configuration changed"**
```bash
terraform init -reconfigure
```
