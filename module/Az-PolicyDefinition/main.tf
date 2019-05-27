data "azurerm_client_config" "current" {
}

resource "azurerm_policy_definition" "policies" {
  count        = length(var.policies)
  name         = "${var.pol_prefix}${var.policies[count.index]["suffix_name"]}${var.pol_suffix}"
  policy_type  = var.policies[count.index]["policy_type"]
  mode         = var.policies[count.index]["mode"]
  display_name = "${var.pol_prefix}${var.policies[count.index]["suffix_name"]}${var.pol_suffix}"
  description  = "Created by App Id : ${data.azurerm_client_config.current.service_principal_application_id}"
  policy_rule = file(
    "${path.module}/json_files/${var.policies[count.index]["suffix_name"]}_policy_rule.json",
  )
  parameters = file(
    "${path.module}/json_files/${var.policies[count.index]["suffix_name"]}_parameters.json",
  )

  lifecycle {
    ignore_changes = [metadata]
  }
}

