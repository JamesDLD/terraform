output "rt_ids" {
  value = azurerm_route_table.route_table.*.id
}

