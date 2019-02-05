output "peers_ops" {
  value = "${azurerm_virtual_network_peering.one_dest_to_source.*.id}"
}
