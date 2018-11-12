output "vnet_names" {
  value = "${data.azurerm_virtual_network.vnets.*.name}"
}

output "vnet_ids" {
  value = "${data.azurerm_virtual_network.vnets.*.id}"
}
