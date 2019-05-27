variable "subscription_id" {type=string}

variable "subnet_resource_group_name" {type=string}

variable "vnet_names" {
  type = list(string)
}

variable "snet_list" {
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

variable "route_table_ids" {
  type = list(string)
}

variable "nsgs_ids" {
  type = list(string)
}

