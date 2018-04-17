output "backup_vault_name" {
  value = "${azurerm_template_deployment.backup_vault.outputs["vaultName"]}"
}

output "backup_vault_rgname" {
  value = "${azurerm_template_deployment.backup_vault.resource_group_name}"
}
