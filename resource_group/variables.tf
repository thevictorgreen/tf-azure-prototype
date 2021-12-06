variable "resource_group_settings" {
  type = object({
      business_divsion = string
      environment = string
      resource_group_name = string
      resource_group_location = string
  })

  default = {
    business_divsion = "data-platform"
    environment = "dev"
    resource_group_location = "eastus2"
    resource_group_name = "rg"
  }
}