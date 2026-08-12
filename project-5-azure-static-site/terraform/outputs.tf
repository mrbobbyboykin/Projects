output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "website_url" {
  description = "Azure Storage static website URL (open in a browser)."
  value       = module.storage_site.primary_web_endpoint
}

output "storage_account_name" {
  value = module.storage_site.storage_account_name
}

output "visitor_api_enabled" {
  value = var.enable_visitor_api
}

output "visitor_api_url" {
  value = var.enable_visitor_api ? module.api[0].visitor_api_url : "(disabled — set enable_visitor_api = true after quota increase)"
}

output "function_app_name" {
  value = var.enable_visitor_api ? module.api[0].function_app_name : "(disabled)"
}
