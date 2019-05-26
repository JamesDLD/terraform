variable "vnets" {
  description="Virtual Networks list."
  type = list(object({
    vnet_suffix_name = string
    address_spaces   = string #For multiple values add spaces between values
    dns_servers      = string              #For multiple values add spaces between values
  }))
}

variable "vnet_prefix" {
  description="Virtual Network name prefix."
  type=string
}

variable "vnet_suffix" {
  description="Virtual Network name suffix."
  type=string
}

variable "vnet_resource_group_name" {
  description="Virtual Network resource group name."
  type=string
}

variable "vnet_location" {
  description="Virtual Network location."
  type=string
}

variable "vnet_tags" {
  description="Virtual Network tags."
  type = map(string)
}

variable "emptylist" {
  type    = list(string)
  default = ["null", "null"]
}

