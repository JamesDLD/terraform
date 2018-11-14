output "paloaltos_names" {
  value = ["${azurerm_template_deployment.paloaltos.*.name}"]
}
