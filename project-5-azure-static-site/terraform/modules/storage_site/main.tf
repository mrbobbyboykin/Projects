variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "site_files" {
  description = "Map of blob name => local file path (uploaded to $web)."
  type        = map(string)
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "site" {
  name                     = substr(replace("${var.project_name}${var.environment}${random_string.suffix.result}", "-", ""), 0, 24)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

locals {
  content_types = {
    html = "text/html; charset=utf-8"
    css  = "text/css; charset=utf-8"
    js   = "application/javascript; charset=utf-8"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    svg  = "image/svg+xml"
    ico  = "image/x-icon"
    json = "application/json"
  }
}

resource "azurerm_storage_blob" "site" {
  for_each = var.site_files

  name                   = each.key
  storage_account_name   = azurerm_storage_account.site.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = each.value
  content_type           = lookup(local.content_types, reverse(split(".", each.key))[0], "application/octet-stream")
  content_md5            = filemd5(each.value)
}

output "storage_account_name" {
  value = azurerm_storage_account.site.name
}

output "storage_account_id" {
  value = azurerm_storage_account.site.id
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.site.primary_web_endpoint
}

output "primary_web_host" {
  value = azurerm_storage_account.site.primary_web_host
}
