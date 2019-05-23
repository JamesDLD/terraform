resource "azurerm_public_ip" "pip" {
  name                = "${var.fw_prefix}-pip1"
  location            = "${var.fw_location}"
  resource_group_name = "${var.fw_resource_group_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = "${var.fw_prefix}"
  location            = "${var.fw_location}"
  resource_group_name = "${azurerm_public_ip.pip.resource_group_name}"
  tags                = "${var.fw_tags}"

  ip_configuration {
    name                 = "${var.fw_prefix}-CFG"
    subnet_id            = "${var.fw_subnet_id}"
    public_ip_address_id = "${azurerm_public_ip.pip.id}"
  }
}
