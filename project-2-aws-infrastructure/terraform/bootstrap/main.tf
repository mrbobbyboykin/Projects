# Bootstrap: Terraform remote state backend (local state only).
# Creates the S3 bucket + DynamoDB lock table used by the main project.
#
#   cd bootstrap
#   terraform init
#   terraform apply
#   terraform output
#
# Then follow ../docs/REMOTE-STATE.md to point the main stack at this backend.
# Do NOT destroy this stack while the main project uses remote state.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "bootstrap"
      ManagedBy   = "terraform"
      Purpose     = "terraform-remote-state"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "portfolio-lab"
}

variable "dynamodb_table_name" {
  type    = string
  default = "portfolio-lab-terraform-locks"
}

locals {
  name_prefix = var.project_name
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "${local.name_prefix}-tfstate-${random_id.suffix.hex}"

  tags = {
    Name = "${local.name_prefix}-tfstate"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional: block accidental deletes of state objects (can complicate destroy — off for lab)
# Use bucket policy in production if desired.

resource "aws_dynamodb_table" "locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = var.dynamodb_table_name
  }
}

output "state_bucket_name" {
  description = "Put this in backend.hcl as bucket ="
  value       = aws_s3_bucket.tfstate.id
}

output "dynamodb_table_name" {
  description = "Put this in backend.hcl as dynamodb_table ="
  value       = aws_dynamodb_table.locks.name
}

output "aws_region" {
  value = var.aws_region
}

output "backend_hcl_snippet" {
  description = "Copy into terraform/backend.hcl (gitignored)."
  value       = <<-EOT
    bucket         = "${aws_s3_bucket.tfstate.id}"
    key            = "project-2/terraform.tfstate"
    region         = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.locks.name}"
    encrypt        = true
  EOT
}
