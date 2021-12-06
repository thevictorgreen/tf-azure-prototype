# Local Input Variables
locals {
  owners               = var.network_settings.general.business_divsion
  environment          = var.network_settings.general.environment
  resource_name_prefix = "${local.owners}-${local.environment}"
  common_tags = {
      owners      = local.owners
      environment = local.environment
  }
}


# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.resource_name_prefix}-${var.network_settings.vnet.name}"
  address_space       = var.network_settings.vnet.cidr_blocks
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = local.common_tags
}


# Create Nat Gateway PUBLIC IP
resource "azurerm_public_ip" "ngw_public_ip" {
  name                = "ngw-public-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.network_settings.nat_gateway.allocation_method
  sku                 = var.network_settings.nat_gateway.sku
  tags                = local.common_tags 
}

# Create Nat Gateway PUBLIC IP PREFIX
resource "azurerm_public_ip_prefix" "ngw_public_ip_prefix" {
  name                = "ngw-public-ip-prefix"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  prefix_length       = var.network_settings.nat_gateway.prefix_length
}

# Create Nat Gateway
resource "azurerm_nat_gateway" "ngw" {
  name                    = "ngw"
  location                = var.resource_group_location
  resource_group_name     = var.resource_group_name
  sku_name                = var.network_settings.nat_gateway.sku
  idle_timeout_in_minutes = var.network_settings.nat_gateway.idle_timeout_in_minutes
}

# Associate NGW Public IP
resource "azurerm_nat_gateway_public_ip_association" "ngw_ip_asso" {
  nat_gateway_id       = azurerm_nat_gateway.ngw.id
  public_ip_address_id = azurerm_public_ip.ngw_public_ip.id
}

# Associate NGW Prefix IP
resource "azurerm_nat_gateway_public_ip_prefix_association" "ngw_ip_prefix_asso" {
  nat_gateway_id      = azurerm_nat_gateway.ngw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.ngw_public_ip_prefix.id
}


# Bastion Subnet
resource "azurerm_subnet" "bastion" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.network_settings.bastion_subnet.name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.network_settings.bastion_subnet.cidr_blocks
}

# Associate Bastion Subnet With Nat Gateway
resource "azurerm_subnet_nat_gateway_association" "bastion_nat_asso" {
  subnet_id      = azurerm_subnet.bastion.id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}

# Create Bastion Subnet Network Security Group
resource "azurerm_network_security_group" "bastion_subnet_nsg" {
  name                = "${azurerm_subnet.bastion.name}-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Bastion Subnet Network Security Group Rules
resource "azurerm_network_security_rule" "bastion_subnet_nsg_rule_inbound_tcp" {
  for_each                    = var.network_settings.bastion_subnet.inbound_tcp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}

resource "azurerm_network_security_rule" "bastion_subnet_nsg_rule_inbound_udp" {
  for_each                    = var.network_settings.bastion_subnet.inbound_udp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}

resource "azurerm_network_security_rule" "bastion_subnet_nsg_rule_inbound_icmp" {
  for_each                    = var.network_settings.bastion_subnet.inbound_icmp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}

# Associate Bastion Subnet With Bastion Network Security Group
resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_asso" { 
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion_subnet_nsg.id
  depends_on = [ azurerm_network_security_rule.bastion_subnet_nsg_rule_inbound_tcp, azurerm_network_security_rule.bastion_subnet_nsg_rule_inbound_udp, azurerm_network_security_rule.bastion_subnet_nsg_rule_inbound_icmp ] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354 
}


# Public Subnet
resource "azurerm_subnet" "public" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.network_settings.public_subnet.name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.network_settings.public_subnet.cidr_blocks
}

# Associate Public Subnet With Nat Gateway
resource "azurerm_subnet_nat_gateway_association" "public_nat_asso" {
  subnet_id      = azurerm_subnet.public.id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}

# Create Public Subnet Network Security Group
resource "azurerm_network_security_group" "public_subnet_nsg" {
  name                = "${azurerm_subnet.public.name}-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Public Subnet Network Security Group Rules
resource "azurerm_network_security_rule" "public_subnet_nsg_rule_inbound_tcp" {
  for_each                    = var.network_settings.public_subnet.inbound_tcp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public_subnet_nsg.name
}

resource "azurerm_network_security_rule" "public_subnet_nsg_rule_inbound_udp" {
  for_each                    = var.network_settings.public_subnet.inbound_udp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public_subnet_nsg.name
}

resource "azurerm_network_security_rule" "public_subnet_nsg_rule_inbound_icmp" {
  for_each                    = var.network_settings.public_subnet.inbound_icmp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public_subnet_nsg.name
}

# Associate Public Subnet With Public Network Security Group
resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg_asso" { 
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public_subnet_nsg.id
  depends_on = [ azurerm_network_security_rule.public_subnet_nsg_rule_inbound_tcp, azurerm_network_security_rule.public_subnet_nsg_rule_inbound_udp, azurerm_network_security_rule.public_subnet_nsg_rule_inbound_icmp  ] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354 
}


# Private Subnet
resource "azurerm_subnet" "private" {
  name                 = "${azurerm_virtual_network.vnet.name}-${var.network_settings.private_subnet.name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.network_settings.private_subnet.cidr_blocks
}

# Associate Private Subnet With Nat Gateway
resource "azurerm_subnet_nat_gateway_association" "private_nat_asso" {
  subnet_id      = azurerm_subnet.private.id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}

# Create Private Subnet Network Security Group
resource "azurerm_network_security_group" "private_subnet_nsg" {
  name                = "${azurerm_subnet.private.name}-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

# Public Subnet Network Security Group Rules
resource "azurerm_network_security_rule" "private_subnet_nsg_rule_inbound_tcp" {
  for_each                    = var.network_settings.private_subnet.inbound_tcp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_subnet_nsg.name
}

resource "azurerm_network_security_rule" "private_subnet_nsg_rule_inbound_udp" {
  for_each                    = var.network_settings.private_subnet.inbound_udp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_subnet_nsg.name
}

resource "azurerm_network_security_rule" "private_subnet_nsg_rule_inbound_icmp" {
  for_each                    = var.network_settings.private_subnet.inbound_icmp_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_subnet_nsg.name
}

# Associate Private Subnet With Private Network Security Group
resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg_asso" { 
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private_subnet_nsg.id
  depends_on = [ azurerm_network_security_rule.private_subnet_nsg_rule_inbound_tcp, azurerm_network_security_rule.private_subnet_nsg_rule_inbound_udp, azurerm_network_security_rule.private_subnet_nsg_rule_inbound_icmp ] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354 
}