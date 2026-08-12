resource "azurerm_resource_group" "this" {
  name     = "${var.project_name}-${var.environment}-p5-rg"
  location = var.location

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    Repository  = "Projects/project-5-azure-static-site"
  }
}

locals {
  site_root = "${path.module}/../site"
  site_files = {
    "index.html" = "${local.site_root}/index.html"
    "styles.css" = "${local.site_root}/styles.css"
    "app.js"     = "${local.site_root}/app.js"
  }
  visitor_api_url = var.enable_visitor_api ? module.api[0].visitor_api_url : "/api/visitors"
}

module "storage_site" {
  source = "./modules/storage_site"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  site_files          = local.site_files
}

module "api" {
  count  = var.enable_visitor_api ? 1 : 0
  source = "./modules/api"

  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  function_source_dir = "${path.module}/function"
  allowed_origins = [
    trimsuffix(module.storage_site.primary_web_endpoint, "/"),
    "https://${module.storage_site.primary_web_host}",
  ]
}

resource "azurerm_storage_blob" "config" {
  name                   = "config.js"
  storage_account_name   = module.storage_site.storage_account_name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "application/javascript; charset=utf-8"
  source_content         = <<-EOT
    window.PORTFOLIO_CONFIG = {
      visitorApiUrl: "${local.visitor_api_url}",
    };
  EOT

  depends_on = [module.storage_site]
}
