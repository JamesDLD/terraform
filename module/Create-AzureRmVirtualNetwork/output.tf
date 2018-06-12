output "vnet_names" {
  value = "${azurerm_virtual_network.vnets.*.name}"
}

output "vnet_ids" {
  value = "${azurerm_virtual_network.vnets.*.id}"
}
