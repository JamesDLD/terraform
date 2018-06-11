output "role_assignment_ids" {
  value = "${azurerm_role_assignment.assignments.*.id}"
}

output "role_assignment_scopes" {
  value = "${azurerm_role_assignment.assignments.*.scope}"
}
