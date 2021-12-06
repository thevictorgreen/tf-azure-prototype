# Local Input Variables
locals {
  owners               = var.vm_settings.general.business_divsion
  environment          = var.vm_settings.general.environment
  resource_name_prefix = "${local.owners}-${local.environment}"
  common_tags = {
      owners      = local.owners
      environment = local.environment
  }
}


# VIRTUAL MACHINE PUBLIC IP
resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.vm_settings.ip_cfg.has_public_ip ? 1 : 0
  name                = "${local.resource_name_prefix}-vm-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = var.vm_settings.ip_cfg.allocation_method
  sku =                 var.vm_settings.ip_cfg.sku
}


# Virtual Machine Network Interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.resource_name_prefix}-vm-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "vm-ip-cfg-01"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.vm_settings.ip_cfg.private_ip_address_allocation
    public_ip_address_id          = var.vm_settings.ip_cfg.has_public_ip ? azurerm_public_ip.vm_public_ip[0].id : null  #azurerm_public_ip.vm_public_ip.id 
  }
}


# AZURE VIRTUAL MACHINE
resource "azurerm_linux_virtual_machine" "vm" {
  name                 = "${local.resource_name_prefix}-vm"
  computer_name        = var.vm_settings.vm_cfg.computer_name
  resource_group_name  = var.resource_group_name
  location             = var.resource_group_location
  size                 = var.vm_settings.vm_cfg.size

  admin_username        = var.vm_settings.vm_cfg.admin_username
  network_interface_ids = [ azurerm_network_interface.vm_nic.id ]

  admin_ssh_key {
    username   = var.vm_settings.vm_cfg.admin_username
    public_key = file("${path.module}${var.vm_settings.vm_cfg.public_key_file_path}")
  }

  os_disk {
    caching              = var.vm_settings.disk_cfg.caching
    storage_account_type = var.vm_settings.disk_cfg.storage_account_type
  }

  source_image_reference {
    publisher = var.vm_settings.image_cfg.publisher
    offer     = var.vm_settings.image_cfg.offer
    sku       = var.vm_settings.image_cfg.sku
    version   = var.vm_settings.image_cfg.version
  }

  custom_data = base64encode(var.vm_settings.vm_custom_data)  
}