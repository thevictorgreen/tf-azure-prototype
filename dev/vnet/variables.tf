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

  default = {
    general = {
      business_divsion = "devops"
      environment = "dev"
    }
    vnet = {
      cidr_blocks = [ "10.100.0.0/16" ]
      name = "data-platform"
    }
    nat_gateway = {
      allocation_method = "Static"
      idle_timeout_in_minutes = 10
      prefix_length = 30
      sku = "Standard"
    }
    bastion_subnet = {
      cidr_blocks = [ "10.100.1.0/24" ]
      inbound_tcp_ports_map = {
        "100" : "22",
        "110" : "3389",
        "120" : "443"
      }
      inbound_udp_ports_map = {}
      inbound_icmp_ports_map = {
        "130" : "*"
      }
      name = "bastion"
    }
    public_subnet = {
      cidr_blocks = [ "10.100.3.0/24" ]
      inbound_tcp_ports_map = {
        "100" : "22",
        "110" : "443",
        "120" : "80",
        "130" : "8080"
      }
      inbound_udp_ports_map = {}
      inbound_icmp_ports_map = {}
      name = "public"
    }
    private_subnet = {
      cidr_blocks = [ "10.100.2.0/24" ]
      inbound_tcp_ports_map = {
        "100" : "22",
        "110" : "3389"
      }
      inbound_udp_ports_map = {}
      inbound_icmp_ports_map = {}
      name = "private"
    }
  }
}