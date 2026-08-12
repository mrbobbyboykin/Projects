data "archive_file" "function" {
  type        = "zip"
  source_dir  = var.function_source_dir
  output_path = "${path.module}/build/function.zip"
}

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

variable "function_source_dir" {
  type = string
}

variable "allowed_origins" {
  type = list(string)
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "function" {
  name                     = substr(replace("${var.project_name}fn${var.environment}${random_string.suffix.result}", "-", ""), 0, 24)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_table" "visits" {
  name                 = "visits"
  storage_account_name = azurerm_storage_account.function.name
}

resource "azurerm_service_plan" "function" {
  name                = "${var.project_name}-${var.environment}-func-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "visitors" {
  name                = substr("${var.project_name}-${var.environment}-visits-${random_string.suffix.result}", 0, 60)
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.function.id

  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  site_config {
    application_stack {
      python_version = "3.11"
    }

    cors {
      allowed_origins     = var.allowed_origins
      support_credentials = false
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "python"
    VISITS_TABLE_NAME              = azurerm_storage_table.visits.name
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    ENABLE_ORYX_BUILD              = "true"
  }

  https_only = true
}

# Zip deploy requires Azure CLI (`az login`) on the machine running terraform apply.
resource "terraform_data" "function_deploy" {
  triggers_replace = [
    data.archive_file.function.output_sha,
    azurerm_linux_function_app.visitors.name,
  ]

  provisioner "local-exec" {
    command = "az functionapp deployment source config-zip --resource-group \"${var.resource_group_name}\" --name \"${azurerm_linux_function_app.visitors.name}\" --src \"${data.archive_file.function.output_path}\" --build-remote true"
  }

  depends_on = [azurerm_linux_function_app.visitors]
}

output "function_app_name" {
  value = azurerm_linux_function_app.visitors.name
}

output "function_default_hostname" {
  value = azurerm_linux_function_app.visitors.default_hostname
}

output "visitor_api_url" {
  value = "https://${azurerm_linux_function_app.visitors.default_hostname}/api/visitors"
}

output "function_storage_account_name" {
  value = azurerm_storage_account.function.name
}
