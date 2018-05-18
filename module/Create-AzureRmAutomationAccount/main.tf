resource "azurerm_automation_account" "auto_acc" {
  name                = "${var.auto_name}"
  location            = "${var.auto_location}"
  resource_group_name = "${var.auto_resource_group_name}"

  sku {
    name = "${var.auto_sku}"
  }

  tags = "${var.auto_tags}"
}

resource "azurerm_automation_credential" "auto_credentials" {
  count               = "${length(var.auto_credentials)}"
  name                = "${lookup(var.auto_credentials[count.index], "Application_Name")}"
  resource_group_name = "${azurerm_automation_account.auto_acc.resource_group_name}"
  account_name        = "${azurerm_automation_account.auto_acc.name}"
  username            = "${lookup(var.auto_credentials[count.index], "Application_Id")}"
  password            = "${lookup(var.auto_credentials[count.index], "Application_Secret")}"
  description         = "Credential for Application Name : ${lookup(var.auto_credentials[count.index], "Application_Name")}"
}
