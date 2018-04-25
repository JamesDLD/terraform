resource "azurerm_application_security_group" "asgs" {
  count               = "${length(var.asgs)}"
  name                = "${var.asg_prefix}${lookup(var.asgs[count.index], "suffix_name")}${var.asg_suffix}"
  location            = "${var.asg_location}"
  resource_group_name = "${var.asg_resource_group_name}"
  tags                = "${var.asg_tags}"
}
