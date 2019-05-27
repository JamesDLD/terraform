output "nsgs_ids" {
  value = azurerm_network_security_group.nsgs.*.id
}

