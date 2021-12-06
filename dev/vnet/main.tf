data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "data-platform-dev-rg-btfrfn"
    storage_account_name = "dataplatformbtfrfn"
    container_name       = "data-platform-terraform"
    key                  = "global/resource_group/terraform.tfstate"
  }
}

locals {
  resource_group_name     = data.terraform_remote_state.rg.outputs.rg_name
  resource_group_location = data.terraform_remote_state.rg.outputs.rg_location
}

module "dev_vnet" {
  source = "../../modules/vnet"

  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location

  network_settings = var.network_settings
}