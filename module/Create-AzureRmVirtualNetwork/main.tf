resource "azurerm_virtual_network" "vnets" {
  count               = "${length(var.vnets)}"
  name                = "${var.vnet_prefix}${lookup(var.vnets[count.index], "vnet_suffix_name")}${var.vnet_suffix}"
  resource_group_name = "${var.vnet_resource_group_name}"
  address_space       = "${split(" ", "${lookup(var.vnets[count.index], "address_spaces")}" )}"                     #["${var.vnet_address_space}"]
  location            = "${var.vnet_location}"

  #dns_servers = "${split(" ", "${lookup(var.vnets[count.index], "dns_servers")}" )}"
  dns_servers = []
  tags        = "${var.vnet_tags}"
}
