resource "azurerm_network_security_group" "nsgs" {
  count               = "${length(var.nsgs)}"
  name                = "${var.nsg_prefix}${lookup(var.nsgs[count.index], "suffix_name")}${var.nsg_suffix}"
  location            = "${var.nsg_location}"
  resource_group_name = "${var.nsg_resource_group_name}"
  tags                = "${var.nsg_tags}"
}

resource "azurerm_network_security_rule" "nsgs_inbound_rules" {
  count                       = "${length(var.nsgrules)}"
  name                        = "${var.nsg_prefix}${lookup(var.nsgrules[count.index], "suffix_name")}-${lookup(var.nsgrules[count.index], "access")}"
  direction                   = "${lookup(var.nsgrules[count.index], "direction")}"
  access                      = "${lookup(var.nsgrules[count.index], "access")}"
  priority                    = "${lookup(var.nsgrules[count.index], "priority")}"
  source_address_prefix       = "${lookup(var.nsgrules[count.index], "source_address_prefix")}"
  destination_address_prefix  = "${lookup(var.nsgrules[count.index], "destination_address_prefix")}"
  destination_port_range      = "${lookup(var.nsgrules[count.index], "destination_port_range")}"
  protocol                    = "${lookup(var.nsgrules[count.index], "protocol")}"
  source_port_range           = "${lookup(var.nsgrules[count.index], "source_port_range")}"
  resource_group_name         = "${var.nsg_resource_group_name}"
  network_security_group_name = "${element(azurerm_network_security_group.nsgs.*.name,lookup(var.nsgrules[count.index], "Id_Nsg"))}"
}
