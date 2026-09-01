provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "EventsByElainaB"
      Business    = "Events by ElainaB LLC"
      Environment = var.environment
      ManagedBy   = "terraform"
      Domain      = var.domain_name
    }
  }
}
