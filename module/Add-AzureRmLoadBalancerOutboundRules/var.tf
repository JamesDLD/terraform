variable "lbs_out" {
  description = "Load balancer properties."
  type = list(object({
    suffix_name            = string
    sku                    = string
    allocatedOutboundPorts = number        #Number of SNAT ports, Load Balancer allocates SNAT ports in multiples of 8.
    idleTimeoutInMinutes   = number        #Outbound flow idle timeout. The parameter accepts a value from 4 to 66.
    enableTcpReset         = bool    #Enable TCP Reset on idle timeout.
    protocol               = string      #Transport protocol of the outbound rule.
  }))
}

variable "lb_out_prefix" {
  type=string
  description = "Prefix used to set a common naming convention on the lb objects."
}

variable "lb_out_suffix" {
    type=string
  description = "Prefix used to set a common naming convention on the lb objects."
}

variable "lb_out_resource_group_name" {
    type=string
  description = "Load balancer resource group name."
}

variable "lbs_tags" {
  type        = map(string)
  description = "Load balancer tags."
}

variable "lb_public_ip_id" {
  type=string
  description = "Id of an existing public ip"
  default     = ""
}

