output "backup_vault_name" {
  value = ["${azurerm_template_deployment.backup_vault.outputs["vaultName"]}"]
}