resource "azurerm_subnet" "subnets" {
  count                     = "${length(var.snets)}"
  name                      = "${var.subnet_prefix}${lookup(var.snets[count.index], "subnet_suffix_name")}${var.subnet_suffix}"
  virtual_network_name      = "${element(var.vnets,lookup(var.snets[count.index], "Id_Vnet"))}"
  resource_group_name       = "${var.subnet_resource_group_name}"
  address_prefix            = "${lookup(var.snets[count.index], "cidr")}"
  network_security_group_id = "${"${lookup(var.snets[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.snets[count.index], "Id_Nsg"))}"}"
  route_table_id            = "${"${lookup(var.snets[count.index], "Id_route_table")}" == "777" ? "" : "${element(var.subnet_route_table_ids,lookup(var.snets[count.index], "Id_route_table"))}"}"
}
