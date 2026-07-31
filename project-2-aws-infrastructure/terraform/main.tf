# Root module — compose infrastructure from child modules.
# Phase 1: VPC
# Phase 2: ALB + ASG
# Phase 3: RDS
# Phase 4: S3 + CloudWatch

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
}

# Without NAT, place ASG in public subnets so user-data can reach dnf repos.
# With NAT, place ASG in private subnets (production-like).
locals {
  asg_subnet_ids          = var.enable_nat_gateway ? module.vpc.private_subnet_ids : module.vpc.public_subnet_ids
  asg_associate_public_ip = !var.enable_nat_gateway
}

module "alb" {
  count  = var.enable_compute ? 1 : 0
  source = "./modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_port          = var.app_port
}

module "asg" {
  count  = var.enable_compute ? 1 : 0
  source = "./modules/asg"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = local.asg_subnet_ids
  target_group_arn      = module.alb[0].target_group_arn
  alb_security_group_id = module.alb[0].security_group_id
  app_port              = var.app_port
  instance_type         = var.instance_type
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
  associate_public_ip   = local.asg_associate_public_ip
}

# Phase 3: RDS in private subnets. Requires enable_compute so the app SG exists.
module "rds" {
  count  = var.enable_rds && var.enable_compute ? 1 : 0
  source = "./modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_security_group_id = module.asg[0].security_group_id
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
  multi_az              = var.rds_multi_az
}

# Phase 4a: private S3 bucket for static assets
module "s3_static" {
  count  = var.enable_s3_static ? 1 : 0
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

# Phase 4b: CloudWatch dashboard + alarms (requires compute)
module "monitoring" {
  count  = var.enable_monitoring && var.enable_compute ? 1 : 0
  source = "./modules/cloudwatch"

  project_name            = var.project_name
  environment             = var.environment
  alb_arn_suffix          = module.alb[0].alb_arn_suffix
  target_group_arn_suffix = module.alb[0].target_group_arn_suffix
  asg_name                = module.asg[0].asg_name
  rds_identifier          = var.enable_rds ? module.rds[0].db_identifier : null
  alarm_email             = var.alarm_email
}
