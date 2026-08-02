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
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }

  # Reuse Project 2 bootstrap state bucket. Copy backend.hcl.example → backend.hcl,
  # set the bucket name, then:
  #   terraform init -backend-config=backend.hcl
  #
  # backend "s3" {}
}
