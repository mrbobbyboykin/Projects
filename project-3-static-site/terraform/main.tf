locals {
  site_root = "${path.module}/../site"
  site_files = {
    "index.html" = "${local.site_root}/index.html"
    "styles.css" = "${local.site_root}/styles.css"
    "app.js"     = "${local.site_root}/app.js"
    "hero.png"   = "${local.site_root}/hero.png"
  }
}

module "s3_site" {
  source = "./modules/s3_site"

  project_name  = var.project_name
  environment   = var.environment
  force_destroy = var.force_destroy_bucket
  site_files    = local.site_files
}

module "dynamodb" {
  source = "./modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
}

module "api" {
  source = "./modules/api"

  project_name      = var.project_name
  environment       = var.environment
  table_name        = module.dynamodb.table_name
  table_arn         = module.dynamodb.table_arn
  lambda_source_dir = "${path.module}/lambda/visitor_counter"
}

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name                   = var.project_name
  environment                    = var.environment
  s3_bucket_id                   = module.s3_site.bucket_id
  s3_bucket_arn                  = module.s3_site.bucket_arn
  s3_bucket_regional_domain_name = module.s3_site.bucket_regional_domain_name
  api_domain_name                = replace(module.api.api_endpoint, "https://", "")
  price_class                    = var.cloudfront_price_class
}
