resource "azurerm_virtual_network" "vnets" {
  count               = length(var.vnets)
  name                = "${var.vnet_prefix}${var.vnets[count.index]["vnet_suffix_name"]}${var.vnet_suffix}"
  resource_group_name = var.vnet_resource_group_name
  address_space       = split(" ", var.vnets[count.index]["address_spaces"])
  location            = var.vnet_location
  dns_servers         = compact(split(" ", var.vnets[count.index]["dns_servers"]))
  tags                = var.vnet_tags
}

resource "azurerm_dns_zone" "private_zones" {
  count                            = length(var.vnets)
  name                             = lookup(var.vnets[count.index], "dns_zone_for_the_registration_vnet", "${var.vnets[count.index]["vnet_suffix_name"]}.az")
  resource_group_name              = "${element(azurerm_virtual_network.vnets.*.resource_group_name, count.index)}"
  zone_type                        = "Private"
  registration_virtual_network_ids = ["${element(azurerm_virtual_network.vnets.*.id, count.index)}"]
  tags                             = var.vnet_tags
}
