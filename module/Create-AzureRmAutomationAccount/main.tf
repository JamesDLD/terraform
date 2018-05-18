resource "azurerm_automation_account" "auto_acc" {
  name                = "${var.auto_name}"
  location            = "${var.auto_location}"
  resource_group_name = "${var.auto_resource_group_name}"

  sku {
    name = "${var.auto_sku}"
  }

  tags = "${var.auto_tags}"
}
