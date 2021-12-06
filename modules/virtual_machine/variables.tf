variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_settings" {
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
}