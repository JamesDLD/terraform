resource "azurerm_template_deployment" "lb_to_addOutboundRule" {
  name                = "${var.lbs_out[0]["suffix_name"]}-bck-DEP"
  resource_group_name = var.lb_out_resource_group_name
  template_body = file(
    "${path.module}/AzureRmLoadBalancerOutboundRules_template.json",
  )
  deployment_mode = "Incremental"

  parameters = {
    lbName                 = "${var.lb_out_prefix}${var.lbs_out[0]["suffix_name"]}${var.lb_out_suffix}"
    tags                   = jsonencode(var.lbs_tags)
    sku                    = var.lbs_out[0]["sku"]
    allocatedOutboundPorts = var.lbs_out[0]["allocatedOutboundPorts"]
    idleTimeoutInMinutes   = var.lbs_out[0]["idleTimeoutInMinutes"]
    enableTcpReset         = var.lbs_out[0]["enableTcpReset"]
    protocol               = var.lbs_out[0]["protocol"]
    lb_public_ip_id        = var.lb_public_ip_id
  }
}

