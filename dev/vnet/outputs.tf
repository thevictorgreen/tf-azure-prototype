## Virtual Network Name
output "virtual_network_name" {
  description = "Virtual Network Name"
  value = module.dev_vnet.virtual_network_name
}
## Virtual Network ID
output "virtual_network_id" {
  description = "Virtual Network ID"
  value = module.dev_vnet.virtual_network_id
}

# Subnet Outputs
## Subnet Name 
output "bastion_subnet_name" {
  description = "Bastion Subnet Name"
  value = module.dev_vnet.bastion_subnet_name
}

## Subnet ID 
output "bastion_subnet_id" {
  description = "Bastion Subnet ID"
  value = module.dev_vnet.bastion_subnet_id
}

## Subnet NSG Name
output "bastion_subnet_nsg_name" {
  description = "Bastion Subnet NSG Name"
  value = module.dev_vnet.bastion_subnet_nsg_name
}

## Subnet NSG ID 
output "bastion_subnet_nsg_id" {
  description = "WebTier Subnet NSG ID"
  value = module.dev_vnet.bastion_subnet_nsg_id
}

## Subnet Name 
output "private_subnet_name" {
  description = "Private Subnet Name"
  value = module.dev_vnet.private_subnet_name
}

## Subnet ID 
output "private_subnet_id" {
  description = "Private Subnet ID"
  value = module.dev_vnet.private_subnet_id
}

## Subnet NSG Name
output "private_subnet_nsg_name" {
  description = "Private Subnet NSG Name"
  value = module.dev_vnet.private_subnet_nsg_name
}

## Subnet NSG ID 
output "private_subnet_nsg_id" {
  description = "Private Subnet NSG ID"
  value = module.dev_vnet.private_subnet_nsg_id
}


## Subnet Name 
output "public_subnet_name" {
  description = "Public Subnet Name"
  value = module.dev_vnet.public_subnet_name
}

## Subnet ID 
output "public_subnet_id" {
  description = "Public Subnet ID"
  value = module.dev_vnet.public_subnet_id
}

## Subnet NSG Name
output "public_subnet_nsg_name" {
  description = "Public Subnet NSG Name"
  value = module.dev_vnet.public_subnet_nsg_name
}

## Subnet NSG ID 
output "public_subnet_nsg_id" {
  description = "Public Subnet NSG ID"
  value = module.dev_vnet.public_subnet_nsg_id
}