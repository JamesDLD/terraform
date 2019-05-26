output "policy_assignment_ids" {
  value = azurerm_policy_assignment.assignments.*.id
}

