variable "lbs_out" {
  description = "Load balancer properties containing those values :suffix_name, sku, allocatedOutboundPorts, idleTimeoutInMinutes, enableTcpReset, protocol"
  type        = "list"
}

variable "lb_out_prefix" {
  description = "Prefix used to set a common naming convention on the lb objects."
}

variable "lb_out_suffix" {
  description = "Prefix used to set a common naming convention on the lb objects."
}

variable "lb_out_resource_group_name" {
  description = "Load balancer resource group name."
}

variable "lbs_tags" {
  type        = "map"
  description = "Load balancer tags."
}