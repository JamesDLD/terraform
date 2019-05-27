resource "azurerm_virtual_network" "vnets" {
  count               = length(var.vnets)
  name                = "${var.vnet_prefix}${var.vnets[count.index]["vnet_suffix_name"]}${var.vnet_suffix}"
  resource_group_name = var.vnet_resource_group_name
  address_space       = split(" ", var.vnets[count.index]["address_spaces"])
  location            = var.vnet_location
  dns_servers = compact(split(" ", var.vnets[count.index]["dns_servers"]))
  tags        = var.vnet_tags
}