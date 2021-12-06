variable "vm1_settings" {
  type = object({
    general = object({
      business_divsion = string
      environment      = string
    })
    ip_cfg = object({
      allocation_method             = string
      sku                           = string
      private_ip_address_allocation = string
      has_public_ip                 = bool
    })
    vm_cfg = object({
      size                 = string
      computer_name        = string
      admin_username       = string
      public_key_file_path = string
    })
    disk_cfg = object({
      caching              = string
      storage_account_type = string
    })
    image_cfg = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    vm_custom_data = string
  })

  default = {
    general = {
      business_divsion = "devops"
      environment      = "dev"
    }
    ip_cfg = {
      allocation_method             = "Static"
      private_ip_address_allocation = "Dynamic"
      sku                           = "Standard"
      has_public_ip                 = true
    }
    vm_cfg = {
      admin_username = "azureuser"
      computer_name = "vm1"
      public_key_file_path = "/zkeys/terraform-azure.pub"
      size = "Standard_DS1_v2"
    }
    disk_cfg = {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    image_cfg = {
      offer = "RHEL"
      publisher = "RedHat"
      sku = "83-gen2"
      version = "latest"
    }
    vm_custom_data = <<CUSTOM_DATA
#!/bin/bash
sudo yum update -y
CUSTOM_DATA
  }
}