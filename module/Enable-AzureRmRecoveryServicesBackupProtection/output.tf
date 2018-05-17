output "backup_deployment_names" {
  value = ["${azurerm_template_deployment.resources_to_backup.*.name}"]
}
