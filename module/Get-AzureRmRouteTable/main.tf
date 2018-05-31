data "azurerm_route_table" "route_table" {
  name                = "${var.rt_name}"
  resource_group_name = "${var.rt_resource_group_name}"
}
