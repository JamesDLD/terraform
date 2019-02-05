output "vnet_names" {
  value = ["${concat(azurerm_virtual_network.vnets.*.name,var.emptylist)}"]
}

output "vnet_rgnames" {
  value = ["${concat(azurerm_virtual_network.vnets.*.resource_group_name,var.emptylist)}"]
}

output "vnet_ids" {
  value = ["${concat(azurerm_virtual_network.vnets.*.id,var.emptylist)}"]
}
