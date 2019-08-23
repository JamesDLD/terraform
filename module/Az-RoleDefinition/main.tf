data "azurerm_subscription" "primary" {
}

resource "azurerm_role_definition" "roles" {
  count              = length(var.roles)
  name               = "${var.role_prefix}${var.roles[count.index]["suffix_name"]}${var.role_suffix}"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions = split(" ", var.roles[count.index]["actions"])

    not_actions = split(" ", var.roles[count.index]["not_actions"])
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

