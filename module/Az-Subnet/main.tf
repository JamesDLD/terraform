resource "null_resource" "subnets_associatiation" {
  count = "${length(var.snet_list)}"

  triggers = {
    nsg_id        = "${"${lookup(var.snet_list[count.index], "nsg_id")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.snet_list[count.index], "nsg_id"))}"}"
    nsg_subnet_id = "${"${lookup(var.snet_list[count.index], "nsg_id")}" == "777" ? "" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.subnet_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${element(var.vnet_names,lookup(var.snet_list[count.index], "vnet_name_id"))}/subnets/${lookup(var.snet_list[count.index],"name")}"}"
    rt_id         = "${"${lookup(var.snet_list[count.index], "route_table_id")}" == "777" ? "" : "${element(var.route_table_ids,lookup(var.snet_list[count.index], "route_table_id"))}"}"
    rt_subnet_id  = "${"${lookup(var.snet_list[count.index], "route_table_id")}" == "777" ? "" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.subnet_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${element(var.vnet_names,lookup(var.snet_list[count.index], "vnet_name_id"))}/subnets/${lookup(var.snet_list[count.index],"name")}"}"
  }
}

locals {
  nsg_ids        = "${compact(null_resource.subnets_associatiation.*.triggers.nsg_id)}"
  nsg_subnet_ids = "${compact(null_resource.subnets_associatiation.*.triggers.nsg_subnet_id)}"
  rt_ids         = "${compact(null_resource.subnets_associatiation.*.triggers.rt_id)}"
  rt_subnet_ids  = "${compact(null_resource.subnets_associatiation.*.triggers.rt_subnet_id)}"
}

# - Code

resource "azurerm_subnet_network_security_group_association" "associations" {
  depends_on                = ["azurerm_subnet.subnets"]
  count                     = "${length(local.nsg_ids)}"
  subnet_id                 = "${element(local.nsg_subnet_ids,count.index)}"
  network_security_group_id = "${element(local.nsg_ids,count.index)}"
}

resource "azurerm_subnet_route_table_association" "associations" {
  depends_on     = ["azurerm_subnet.subnets"]
  count          = "${length(local.rt_ids)}"
  subnet_id      = "${element(local.rt_subnet_ids,count.index)}"
  route_table_id = "${element(local.rt_ids,count.index)}"
}

resource "azurerm_subnet" "subnets" {
  count                = "${length(var.snet_list)}"
  name                 = "${lookup(var.snet_list[count.index],"name")}"
  resource_group_name  = "${var.subnet_resource_group_name}"
  virtual_network_name = "${element(var.vnet_names,lookup(var.snet_list[count.index], "vnet_name_id"))}"
  address_prefix       = "${lookup(var.snet_list[count.index],"cidr_block")}"
  service_endpoints    = ["${compact(split(" ", "${lookup(var.snet_list[count.index], "service_endpoints")}" ))}"]

  lifecycle {
    ignore_changes = ["route_table_id", "network_security_group_id"]
  }
}
