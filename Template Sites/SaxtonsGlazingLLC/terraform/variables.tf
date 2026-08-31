variable "aws_region" {
  description = "Must be us-east-1 for CloudFront ACM certificates."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "name_prefix" {
  description = "Short prefix for AWS resource names (letters/numbers/hyphens)."
  type        = string
  default     = "saxtonsglazing"
}

variable "domain_name" {
  description = "Apex domain for the business website."
  type        = string
  default     = "saxtonsglazing.com"
}

variable "enable_route53" {
  description = "Create Route 53 hosted zone + alias records for apex and www. Set false until a domain is registered."
  type        = bool
  default     = false
}

variable "cloudfront_price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "force_destroy_bucket" {
  description = "Allow terraform destroy even if the site bucket has objects."
  type        = bool
  default     = true
}
