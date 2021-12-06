output "vm_public_ip" {
  description = "VM Public Address"
  value = "${var.vm_settings.ip_cfg.has_public_ip ? azurerm_public_ip.vm_public_ip[0].ip_address : ""}"  #azurerm_public_ip.vm_public_ip.ip_address
}