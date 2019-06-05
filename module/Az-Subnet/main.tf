resource "null_resource" "subnets_associatiation" {
  count = length(var.snet_list)

  triggers = {
    nsg_id        = var.snet_list[count.index]["nsg_id"] == 777 ? "" : element(var.nsgs_ids, var.snet_list[count.index]["nsg_id"])
    nsg_subnet_id = var.snet_list[count.index]["nsg_id"] == 777 ? "" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.subnet_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${element(var.vnet_names, var.snet_list[count.index]["vnet_name_id"])}/subnets/${var.snet_list[count.index]["name"]}"
    rt_id = var.snet_list[count.index]["route_table_id"] == 777 ? "" : element(
      var.route_table_ids,
      var.snet_list[count.index]["route_table_id"],
    )
    rt_subnet_id = var.snet_list[count.index]["route_table_id"] == 777 ? "" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.subnet_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${element(var.vnet_names, var.snet_list[count.index]["vnet_name_id"])}/subnets/${var.snet_list[count.index]["name"]}"
  }
}

locals {
  nsg_ids = compact(null_resource.subnets_associatiation.*.triggers.nsg_id)
  nsg_subnet_ids = compact(
    null_resource.subnets_associatiation.*.triggers.nsg_subnet_id,
  )
  rt_ids        = compact(null_resource.subnets_associatiation.*.triggers.rt_id)
  rt_subnet_ids = compact(null_resource.subnets_associatiation.*.triggers.rt_subnet_id)
}

# - Code

resource "azurerm_subnet_network_security_group_association" "associations" {
  depends_on                = [azurerm_subnet.subnets]
  count                     = length(local.nsg_ids)
  subnet_id                 = element(local.nsg_subnet_ids, count.index)
  network_security_group_id = element(local.nsg_ids, count.index)
}

resource "azurerm_subnet_route_table_association" "associations" {
  depends_on     = [azurerm_subnet.subnets]
  count          = length(local.rt_ids)
  subnet_id      = element(local.rt_subnet_ids, count.index)
  route_table_id = element(local.rt_ids, count.index)
}

resource "azurerm_subnet" "subnets" {
  count                     = length(var.snet_list)
  name                      = var.snet_list[count.index]["name"]
  resource_group_name       = var.subnet_resource_group_name
  virtual_network_name      = element(var.vnet_names, var.snet_list[count.index]["vnet_name_id"])
  address_prefix            = var.snet_list[count.index]["cidr_block"]
  service_endpoints         = compact(split(" ", var.snet_list[count.index]["service_endpoints"]))
  network_security_group_id = var.snet_list[count.index]["nsg_id"] == 777 ? null : element(var.nsgs_ids, var.snet_list[count.index]["nsg_id"])
  route_table_id = var.snet_list[count.index]["route_table_id"] == 777 ? null : element(
    var.route_table_ids,
    var.snet_list[count.index]["route_table_id"],
  )
  /*
  lifecycle {
    ignore_changes = [
      route_table_id,
      network_security_group_id,
    ]
  }
  */
}

