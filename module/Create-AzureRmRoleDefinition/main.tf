data "azurerm_subscription" "primary" {}

resource "azurerm_role_definition" "roles" {
  count              = "${length(var.roles)}"
  name               = "${var.role_prefix}${lookup(var.roles[count.index], "suffix_name")}${var.role_suffix}"
  role_definition_id = "${lookup(var.roles[count.index], "role_definition_id")}"
  scope              = "${data.azurerm_subscription.primary.id}"

  permissions {
    actions = "${split(" ", lookup(var.roles[count.index], "actions") )}"

    not_actions = "${split(" ", lookup(var.roles[count.index], "not_actions") )}"
  }

  assignable_scopes = [
    "${data.azurerm_subscription.primary.id}",
  ]
}
