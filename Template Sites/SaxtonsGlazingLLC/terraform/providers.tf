provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "SaxtonsGlazing"
      Business    = "Saxton's Glazing & Aluminum LLC"
      Environment = var.environment
      ManagedBy   = "terraform"
      Domain      = var.domain_name
    }
  }
}
