terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: reuse Project 2 bootstrap state bucket.
  # Copy backend.hcl.example → backend.hcl, then uncomment:
  # backend "s3" {}
}
