output "lb_to_addOutboundRule_deployment_name" {
  value = azurerm_template_deployment.lb_to_addOutboundRule.name
}

output "lb_backend_id" {
  value = azurerm_template_deployment.lb_to_addOutboundRule.outputs["load_balancer_backend_address_pools_id"]
}

