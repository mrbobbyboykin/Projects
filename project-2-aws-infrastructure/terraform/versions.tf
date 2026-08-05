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

  # Phase 5 — remote state (see terraform/bootstrap/ and backend.hcl.example)
  # 1) Apply terraform/bootstrap
  # 2) Create backend.hcl from backend.hcl.example
  # 3) Uncomment this block, then:
  #      terraform init -backend-config=backend.hcl
  #
   backend "s3" {}
}
