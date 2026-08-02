variable "project_name" {
  type    = string
  default = "portfolio-lab"
}

variable "environment" {
  type    = string
  default = "lab"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "github_owner" {
  description = "GitHub user or org"
  type        = string
  default     = "mrbobbyboykin"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "Projects"
}

variable "github_branch" {
  type    = string
  default = "main"
}

variable "site_bucket_name" {
  description = "Project 3 S3 bucket name (terraform -chdir=../project-3-static-site/terraform output -raw site_bucket_name)"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "Project 3 CloudFront distribution ID"
  type        = string
}

variable "force_destroy_artifacts" {
  description = "Allow destroy to empty the pipeline artifacts bucket"
  type        = bool
  default     = true
}
