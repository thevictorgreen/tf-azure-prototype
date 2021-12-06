data "terraform_remote_state" "rg" {
  backend = "azurerm"
  config = {
    resource_group_name  = "data-platform-dev-rg-btfrfn"
    storage_account_name = "dataplatformbtfrfn"
    container_name       = "data-platform-terraform"
    key                  = "global/resource_group/terraform.tfstate"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "data-platform-dev-rg-btfrfn"
    storage_account_name = "dataplatformbtfrfn"
    container_name       = "data-platform-terraform"
    key                  = "dev/vnet/terraform.tfstate"
  }
}

locals {
  resource_group_name     = data.terraform_remote_state.rg.outputs.rg_name
  resource_group_location = data.terraform_remote_state.rg.outputs.rg_location
  subnet_id               = data.terraform_remote_state.vnet.outputs.bastion_subnet_id
}


module "vm1" {
  source = "../../modules/virtual_machine"

  resource_group_name     = local.resource_group_name
  resource_group_location = local.resource_group_location
  subnet_id               = local.subnet_id

  vm_settings             = var.vm1_settings
}