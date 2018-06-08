output "role_ids" {
  value = "${azurerm_role_definition.roles.*.id}"
}
