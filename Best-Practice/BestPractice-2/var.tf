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

variable "subnets" {
  description="Subnet list."
  type = list(object({
    name              = string
    cidr_block        = string
    nsg_id            = number                                                                                                                                               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = number                                                                                                                                               #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = number                                                                                                                                                 #Id of the vnet
    service_endpoints = string #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  }))
}
