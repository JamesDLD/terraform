data "azurerm_subscription" "primary" {
}

resource "random_id" "role_definition_ids" {
  count       = length(var.roles)
  byte_length = 16
}

resource "azurerm_role_definition" "roles" {
  count              = length(var.roles)
  name               = "${var.role_prefix}${var.roles[count.index]["suffix_name"]}${var.role_suffix}"
  role_definition_id = element(random_id.role_definition_ids.*.hex, count.index)
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions = split(" ", var.roles[count.index]["actions"])

    not_actions = split(" ", var.roles[count.index]["not_actions"])
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id,
  ]
}

