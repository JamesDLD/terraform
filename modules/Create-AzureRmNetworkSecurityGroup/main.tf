resource "azurerm_network_security_group" "nsgs_subnet" {
  count               = "${length(var.snets)}"
  name                = "${var.nsg_prefix}${lookup(var.snets[count.index], "subnet_suffix_name")}${var.nsg_suffix}"
  location            = "${var.nsg_location}"
  resource_group_name = "${var.nsg_resource_group_name}"
  tags                = "${var.nsg_tags}"
}

resource "azurerm_network_security_rule" "nsgs_subnet_inbound_rules" {
  count                       = "${length(var.nsgrules)}"
  name                        = "${var.nsg_prefix}${lookup(var.nsgrules[count.index], "suffix_name")}-${lookup(var.nsgrules[count.index], "access")}"
  direction                   = "Inbound"
  access                      = "${lookup(var.nsgrules[count.index], "access")}"
  priority                    = "${lookup(var.nsgrules[count.index], "priority")}"
  source_address_prefix       = "${lookup(var.nsgrules[count.index], "source_address_prefix")}"
  destination_address_prefix  = "${lookup(var.nsgrules[count.index], "destination_address_prefix")}"
  destination_port_range      = "${lookup(var.nsgrules[count.index], "destination_port_range")}"
  protocol                    = "${lookup(var.nsgrules[count.index], "protocol")}"
  source_port_range           = "${lookup(var.nsgrules[count.index], "source_port_range")}"
  resource_group_name         = "${var.nsg_resource_group_name}"
  network_security_group_name = "${element(azurerm_network_security_group.nsgs_subnet.*.name,index(azurerm_network_security_group.nsgs_subnet.*.name,"${var.nsg_prefix}${lookup(var.nsgrules[count.index], "subnet_suffix_name")}${var.nsg_suffix}"))}"
}
