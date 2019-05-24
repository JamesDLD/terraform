output "Linux_nics_names" {
  value = azurerm_network_interface.linux_vms_nics.*.name
}

output "Linux_nics_ids" {
  value = azurerm_network_interface.linux_vms_nics.*.id
}

output "Linux_nics_private_ip_address" {
  value = azurerm_network_interface.linux_vms_nics.*.private_ip_address
}

output "Windows_nics_names" {
  value = azurerm_network_interface.Windows_Vms_nics.*.name
}

output "Windows_nics_ids" {
  value = azurerm_network_interface.Windows_Vms_nics.*.id
}

output "Windows_nics_private_ip_address" {
  value = azurerm_network_interface.Windows_Vms_nics.*.private_ip_address
}

