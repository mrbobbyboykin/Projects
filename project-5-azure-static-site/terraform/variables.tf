variable "project_name" {
  description = "Name prefix for resources."
  type        = string
  default     = "portfoliolab"
}

variable "environment" {
  type    = string
  default = "lab"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "enable_visitor_api" {
  description = "Create Azure Function + Table Storage counter. Set false if your subscription has 0 compute VM quota (new free accounts)."
  type        = bool
  default     = true
}
