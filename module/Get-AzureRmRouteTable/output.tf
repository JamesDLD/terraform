output "rt_id" {
  value = "${data.azurerm_route_table.route_table.id}"
}

output "rt_name" {
  value = "${data.azurerm_route_table.route_table.name}"
}
