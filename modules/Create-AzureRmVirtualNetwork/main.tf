resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  resource_group_name = "${var.vnet_resource_group_name}"
  address_space       = ["${var.vnet_address_space}"]
  location            = "${var.vnet_location}"

  #dns_servers         = ["${var.vnet_dns1}", "${var.vnet_dns2}"]
  tags = "${var.vnet_tags}"
}
