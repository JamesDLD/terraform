resource "azurerm_template_deployment" "lb_to_addOutboundRule" {
  count               = "${length(var.lbs_out)}"
  name                = "${lookup(var.lbs_out[count.index], "suffix_name")}-bck-DEP"
  resource_group_name = "${var.lb_out_resource_group_name}"
  template_body       = "${file("../module/Add-AzureRmLoadBalancerOutboundRules/AzureRmLoadBalancerOutboundRules_template.json")}"
  deployment_mode     = "Incremental"

  parameters = {
    lbName                 = "${var.lb_out_prefix}${lookup(var.lbs_out[count.index], "suffix_name")}${var.lb_out_suffix}"
    tags                   = "${jsonencode(var.lbs_tags)}"
    sku                    = "${lookup(var.lbs_out[count.index], "sku")}"
    allocatedOutboundPorts = "${lookup(var.lbs_out[count.index], "allocatedOutboundPorts")}"
    idleTimeoutInMinutes   = "${lookup(var.lbs_out[count.index], "idleTimeoutInMinutes")}"
    enableTcpReset         = "${lookup(var.lbs_out[count.index], "enableTcpReset")}"
    protocol               = "${lookup(var.lbs_out[count.index], "protocol")}"
  }
}
