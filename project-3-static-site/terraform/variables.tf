variable "project_name" {
  description = "Name prefix for resources."
  type        = string
  default     = "portfolio-lab"
}

variable "environment" {
  description = "Environment label (e.g. lab)."
  type        = string
  default     = "lab"
}

variable "aws_region" {
  description = "AWS region for regional resources (API, DynamoDB, S3, Lambda)."
  type        = string
  default     = "us-east-1"
}

variable "force_destroy_bucket" {
  description = "Allow terraform destroy to empty the site bucket."
  type        = bool
  default     = true
}

variable "cloudfront_price_class" {
  description = "CloudFront price class (PriceClass_100 is cheapest)."
  type        = string
  default     = "PriceClass_100"
}
