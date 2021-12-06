## Virtual Network Name
output "virtual_network_name" {
  description = "Virtual Network Name"
  value = azurerm_virtual_network.vnet.name
}
## Virtual Network ID
output "virtual_network_id" {
  description = "Virtual Network ID"
  value = azurerm_virtual_network.vnet.id
}

# Subnet Outputs
## Subnet Name 
output "bastion_subnet_name" {
  description = "Bastion Subnet Name"
  value = azurerm_subnet.bastion.name
}

## Subnet ID 
output "bastion_subnet_id" {
  description = "Bastion Subnet ID"
  value = azurerm_subnet.bastion.id
}

## Subnet NSG Name
output "bastion_subnet_nsg_name" {
  description = "Bastion Subnet NSG Name"
  value = azurerm_network_security_group.bastion_subnet_nsg.name
}

## Subnet NSG ID 
output "bastion_subnet_nsg_id" {
  description = "WebTier Subnet NSG ID"
  value = azurerm_network_security_group.bastion_subnet_nsg.id
}

## Subnet Name 
output "private_subnet_name" {
  description = "Private Subnet Name"
  value = azurerm_subnet.private.name
}

## Subnet ID 
output "private_subnet_id" {
  description = "Private Subnet ID"
  value = azurerm_subnet.private.id
}

## Subnet NSG Name
output "private_subnet_nsg_name" {
  description = "Private Subnet NSG Name"
  value = azurerm_network_security_group.private_subnet_nsg.name
}

## Subnet NSG ID 
output "private_subnet_nsg_id" {
  description = "Private Subnet NSG ID"
  value = azurerm_network_security_group.private_subnet_nsg.id
}


## Subnet Name 
output "public_subnet_name" {
  description = "Public Subnet Name"
  value = azurerm_subnet.public.name
}

## Subnet ID 
output "public_subnet_id" {
  description = "Public Subnet ID"
  value = azurerm_subnet.public.id
}

## Subnet NSG Name
output "public_subnet_nsg_name" {
  description = "Public Subnet NSG Name"
  value = azurerm_network_security_group.public_subnet_nsg.name
}

## Subnet NSG ID 
output "public_subnet_nsg_id" {
  description = "Public Subnet NSG ID"
  value = azurerm_network_security_group.public_subnet_nsg.id
}