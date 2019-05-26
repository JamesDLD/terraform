#Variables declaration

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "client_id" {
  description = "Azure service principal application Id"
}

variable "client_secret" {
  description = "Azure service principal application Secret"
}

variable "lbs_public" {
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