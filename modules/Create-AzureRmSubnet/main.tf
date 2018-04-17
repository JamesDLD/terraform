resource "azurerm_route_table" "route_table" {
  name                = "${var.rt_name}"
  location            = "${var.rt_location}"
  resource_group_name = "${var.rt_resource_group_name}"
  tags                = "${var.rt_tags}"
}

resource "azurerm_route" "routes" {
  count                  = "${length(var.rt_routes)}"
  name                   = "${lookup(var.rt_routes[count.index], "name")}"
  resource_group_name    = "${var.rt_resource_group_name}"
  route_table_name       = "${azurerm_route_table.route_table.name}"
  address_prefix         = "${lookup(var.rt_routes[count.index], "address_prefix")}"
  next_hop_type          = "${lookup(var.rt_routes[count.index], "next_hop_type")}"
  next_hop_in_ip_address = "${lookup(var.rt_routes[count.index], "next_hop_in_ip_address")}"
}

resource "azurerm_subnet" "subnets" {
  count                     = "${length(var.snets)}"
  name                      = "${var.subnet_prefix}${lookup(var.snets[count.index], "subnet_suffix_name")}${var.subnet_suffix}"
  virtual_network_name      = "${var.vnet_name}"
  resource_group_name       = "${var.subnet_resource_group_name}"
  address_prefix            = "${lookup(var.snets[count.index], "cidr")}"
  network_security_group_id = "${element(var.subnet_nsgs_ids,count.index)}"
  route_table_id            = "${azurerm_route_table.route_table.id}"
}
