output "Linux_nics_ids" {
  value = "${azurerm_network_interface.linux_vms_nics.*.id}"
}

output "Windows_nics_ids" {
  value = "${azurerm_network_interface.Windows_Vms_nics.*.id}"
}
