variable "project_name" {
  description = "Name prefix for resources."
  type        = string
  default     = "project6"
}

variable "environment" {
  description = "Environment label (e.g. lab)."
  type        = string
  default     = "lab"
}

variable "aws_region" {
  description = "AWS region for ECR and later ECS resources."
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "ECR repository name for the API image."
  type        = string
  default     = "project6-api"
}

variable "ecr_force_delete" {
  description = "Allow terraform destroy even if images remain (lab convenience)."
  type        = bool
  default     = true
}

variable "ecr_scan_on_push" {
  description = "Enable ECR image scanning on push."
  type        = bool
  default     = true
}

variable "ecr_keep_image_count" {
  description = "Lifecycle policy: keep only this many tagged images."
  type        = number
  default     = 5
}
