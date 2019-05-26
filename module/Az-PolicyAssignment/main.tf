data "azurerm_client_config" "current" {
}

resource "azurerm_policy_assignment" "assignments" {
  name                 = var.p_ass_name
  scope                = var.p_ass_scope
  policy_definition_id = var.p_ass_policy_definition_id
  description          = "Assigned by App Id : ${data.azurerm_client_config.current.service_principal_application_id}"
  display_name         = var.p_ass_name

  parameters = <<PARAMETERS
{
  "${var.p_ass_key_parameter1}": {
    "value": "${var.p_ass_value_parameter1}"
  }
}
PARAMETERS

}

