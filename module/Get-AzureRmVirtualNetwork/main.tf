data "azurerm_virtual_network" "vnets" {
  count               = length(var.vnets)
  name                = element(var.vnets, count.index)
  resource_group_name = var.vnet_resource_group_name
}

