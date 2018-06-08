output "role_assignment_ids" {
  value = "${azurerm_role_assignment.assignments.*.id}"
}
