variable "project_name" {
  description = "Short name used in resource names and tags."
  type        = string
  default     = "portfolio-lab"
}

variable "environment" {
  description = "Environment label (e.g. lab, dev)."
  type        = string
  default     = "lab"
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Two AZs for multi-AZ subnet layout (must exist in aws_region)."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "One public subnet per AZ (ALB, NAT)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "One private subnet per AZ (app tier, RDS)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Create a single NAT gateway for private subnet egress (lab cost control: one NAT)."
  type        = bool
  default     = true
}

# --- Phase 2: ALB + ASG ---

variable "enable_compute" {
  description = "When true, create ALB + ASG (Phase 2)."
  type        = bool
  default     = false
}

variable "app_port" {
  description = "Application / target group port."
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "EC2 instance type for ASG (free-tier friendly default)."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 2
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

# --- Phase 3: RDS ---

variable "enable_rds" {
  description = "When true, create RDS (requires enable_compute for app SG)."
  type        = bool
  default     = false
}

variable "rds_multi_az" {
  description = "Multi-AZ RDS standby. Keep false for cheap lab runs."
  type        = bool
  default     = false
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

# --- Phase 4 toggles ---

variable "enable_s3_static" {
  description = "When true, create S3 static assets module (not implemented yet)."
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "When true, create CloudWatch dashboards/alarms (not implemented yet)."
  type        = bool
  default     = false
}
