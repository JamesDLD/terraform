output "backup_vault_names" {
  value = ["${azurerm_template_deployment.backup_vaults.*.name}"]
}
