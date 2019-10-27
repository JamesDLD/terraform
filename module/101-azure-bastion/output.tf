output "bastion_id" {
  value = azurerm_template_deployment.bastion.outputs["resourceID"]
}
