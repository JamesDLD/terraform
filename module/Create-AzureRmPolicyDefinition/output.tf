output "policy_ids" {
  value = "${azurerm_policy_definition.policies.*.id}"
}
