resource "azurerm_template_deployment" "lb_to_addOutboundRule" {
  count               = "${length(var.lbs_out)}"
  name                = "${lookup(var.lbs_out[count.index], "suffix_name")}-bck-DEP"
  resource_group_name = "${var.lb_out_resource_group_name}"
  template_body       = "${file("../module/Add-AzureRmLoadBalancerOutboundRules/AzureRmLoadBalancerOutboundRules_template.json")}"
  deployment_mode     = "Incremental"

  parameters = {
    lbName                                         = "${var.lb_out_prefix}${lookup(var.lbs_out[count.index], "suffix_name")}${var.lb_out_suffix}"
    frontend_ip_configuration_name                 = "${lookup(var.lbs_out[count.index], "suffix_name")}"
    frontend_ip_configuration_public_ip_address_id = "${element(var.lb_out_frontend_ip_configuration_public_ip_address_ids,count.index)}"
    allocatedOutboundPorts                         = "${lookup(var.lbs_out[count.index], "allocatedOutboundPorts")}"
    idleTimeoutInMinutes                           = "${lookup(var.lbs_out[count.index], "idleTimeoutInMinutes")}"
    enableTcpReset                                 = "${lookup(var.lbs_out[count.index], "enableTcpReset")}"
    protocol                                       = "${lookup(var.lbs_out[count.index], "protocol")}"
    backendAddressPool                             = "${element(var.lb_out_backend_ids,count.index)}"
  }
}
