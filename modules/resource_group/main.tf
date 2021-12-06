resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}

locals {
  owners               = var.resource_group_settings.business_divsion
  environment          = var.resource_group_settings.environment
  resource_name_prefix = "${local.owners}-${local.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name_prefix}-${var.resource_group_settings.resource_group_name}-${random_string.myrandom.id}"
  location = var.resource_group_settings.resource_group_location
  tags     = local.common_tags
}