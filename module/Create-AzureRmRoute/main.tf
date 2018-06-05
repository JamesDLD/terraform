resource "azurerm_route_table" "route_table" {
  count               = "${length(var.route_tables)}"
  name                = "${var.rt_prefix}${lookup(var.route_tables[count.index], "route_suffix_name")}${var.rt_suffix}"
  location            = "${var.rt_location}"
  resource_group_name = "${var.rt_resource_group_name}"
  tags                = "${var.rt_tags}"
}

resource "azurerm_route" "routes" {
  count                  = "${length(var.routes)}"
  name                   = "${lookup(var.routes[count.index], "name")}"
  resource_group_name    = "${var.rt_resource_group_name}"
  route_table_name       = "${element(azurerm_route_table.route_table.*.name,lookup(var.routes[count.index], "Id_rt"))}"
  address_prefix         = "${lookup(var.routes[count.index], "address_prefix")}"
  next_hop_type          = "${lookup(var.routes[count.index], "next_hop_type")}"
  next_hop_in_ip_address = "${lookup(var.routes[count.index], "next_hop_in_ip_address")}"
}
