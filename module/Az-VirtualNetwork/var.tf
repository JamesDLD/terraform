# -
# - Core object
# -
variable "net_location" {
  description = "Network resources location if different that the resource group's location."
  type        = string
  default     = ""
}

variable "net_tags" {
  description = "Network resources tags."
  type        = map(string)
  default     = {}
}

variable "net_prefix" {
  description = "Virtual Network name prefix."
  type        = string
}

variable "network_resource_group_name" {
  description = "The resource group name of the network resources."
  type        = string
}

variable "network_ddos_protection_plan" {
  description = "Network network ddos protection plan parameters."
  type        = any
  default     = []
}

# -
# - Network object
# -
variable "virtual_networks" {
  description = "The virtal networks with their properties."
  type        = any
  /*
  #This implies a crash described here https://github.com/hashicorp/terraform/issues/22082 -->
  type = list(object({
    id            = string
    address_space = list(string)
    subnets       = any
    bastion       = bool
  }))
  */
}
variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type        = any
}
# -
# - Route Table
# -
variable "route_tables" {
  description = "The route tables with their properties."
  type        = any
}

# -
# - Network Security Group
# -
variable "network_security_groups" {
  description = "The network security groups with their properties."
  type        = any
  /*
  #This implies a crash described here https://github.com/hashicorp/terraform/issues/22082 -->
  type = list(object({
    id             = string
    security_rules = any
  }))
  */
}

