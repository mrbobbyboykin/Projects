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

# -----------------------------------------------------------------------------
# Phase 2 — VPC / ECS / ALB
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR for the lab VPC."
  type        = string
  default     = "10.60.0.0/16"
}

variable "container_port" {
  description = "Port the Flask app listens on inside the container."
  type        = number
  default     = 8080
}

variable "image_tag" {
  description = "ECR image tag to deploy."
  type        = string
  default     = "latest"
}

variable "fargate_cpu" {
  description = "Fargate CPU units (256 = 0.25 vCPU)."
  type        = string
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate memory in MiB."
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of Fargate tasks. Set 0 to stop paying for tasks (ALB still costs)."
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention for the API."
  type        = number
  default     = 7
}

variable "app_secret_demo" {
  description = "Demo secret value stored in Secrets Manager (Phase 3). Not injected as plaintext env in the task definition."
  type        = string
  default     = "phase3-secrets-manager-demo"
  sensitive   = true
}
