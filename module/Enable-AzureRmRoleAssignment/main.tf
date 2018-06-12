resource "azurerm_role_assignment" "assignments" {
  count              = "${var.ass_countRoleAssignment}"
  scope              = "${element(var.ass_scopes,count.index)}"
  role_definition_id = "${element(var.ass_role_definition_ids,count.index)}"
  principal_id       = "${var.ass_principal_id}"
}
