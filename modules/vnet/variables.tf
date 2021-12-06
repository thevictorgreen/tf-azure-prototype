variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "network_settings" {
  type = object({
      general = object({
          business_divsion = string
          environment      = string
      })
      vnet = object({
          name        = string
          cidr_blocks = list(string)
      })
      nat_gateway = object({
          allocation_method       = string
          sku                     = string
          prefix_length           = number
          idle_timeout_in_minutes = number
      })
      bastion_subnet = object({
          name                   = string
          cidr_blocks            = list(string)
          inbound_tcp_ports_map  = map(string)
          inbound_udp_ports_map  = map(string)
          inbound_icmp_ports_map = map(string)
      })
      public_subnet = object({
          name                   = string
          cidr_blocks            = list(string)
          inbound_tcp_ports_map  = map(string)
          inbound_udp_ports_map  = map(string)
          inbound_icmp_ports_map = map(string)
      })
      private_subnet = object({
          name                   = string
          cidr_blocks            = list(string)
          inbound_tcp_ports_map  = map(string)
          inbound_udp_ports_map  = map(string)
          inbound_icmp_ports_map = map(string)
      })
  })
}