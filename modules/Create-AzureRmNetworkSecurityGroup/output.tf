output "nsgs_subnet_ids" {
  value = "${azurerm_network_security_group.nsgs_subnet.*.id}"
}
