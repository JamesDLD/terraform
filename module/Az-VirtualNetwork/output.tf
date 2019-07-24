# -
# - Network
# -

output "vnets_with_bastion" {
  value = local.vnets_with_bastion
}
output "vnets_with_out_bastion" {
  value = local.vnets_with_out_bastion
}

output "vnet_ids" {
  value = azurerm_virtual_network.vnets.*.id
}

output "vnet_names" {
  value = azurerm_virtual_network.vnets.*.name
}

output "vnet_rgnames" {
  value = azurerm_virtual_network.vnets.*.resource_group_name
}

output "subnet_ids" {
  value = azurerm_subnet.subnets.*.id
}
output "network_security_group_ids" {
  value = azurerm_network_security_group.nsgs.*.id
}
