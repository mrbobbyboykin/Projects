# Root module — compose infrastructure from child modules.
# Phase 1 (current): VPC foundation only.
# Phase 2+: enable toggles in terraform.tfvars as ALB, ASG, RDS, S3, CloudWatch modules land.

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

# --- Phase 2 stubs (uncomment when modules are ready) ---

# module "alb" {
#   count  = var.enable_compute ? 1 : 0
#   source = "./modules/alb"
#
#   project_name       = var.project_name
#   environment        = var.environment
#   vpc_id             = module.vpc.vpc_id
#   public_subnet_ids  = module.vpc.public_subnet_ids
#   private_subnet_ids = module.vpc.private_subnet_ids
# }

# module "asg" {
#   count  = var.enable_compute ? 1 : 0
#   source = "./modules/asg"
#
#   project_name        = var.project_name
#   environment         = var.environment
#   vpc_id              = module.vpc.vpc_id
#   private_subnet_ids  = module.vpc.private_subnet_ids
#   target_group_arn    = module.alb[0].target_group_arn
#   alb_security_group_id = module.alb[0].security_group_id
# }

# module "rds" {
#   count  = var.enable_rds ? 1 : 0
#   source = "./modules/rds"
#
#   project_name         = var.project_name
#   environment          = var.environment
#   vpc_id               = module.vpc.vpc_id
#   private_subnet_ids   = module.vpc.private_subnet_ids
#   app_security_group_id = module.asg[0].security_group_id
# }

# module "s3_static" {
#   count  = var.enable_s3_static ? 1 : 0
#   source = "./modules/s3"
#
#   project_name = var.project_name
#   environment  = var.environment
# }

# module "monitoring" {
#   count  = var.enable_monitoring ? 1 : 0
#   source = "./modules/cloudwatch"
#
#   project_name = var.project_name
#   environment  = var.environment
#   # alb_arn, asg_name, rds_id — pass from other modules
# }
