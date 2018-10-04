output "lb_to_addOutboundRule_deployment_names" {
  value = ["${azurerm_template_deployment.lb_to_addOutboundRule.*.name}"]
}
