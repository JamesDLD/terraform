variable "vnet_name" {}
variable "vnet_resource_group_name" {}
variable "vnet_address_space" {}
variable "vnet_location" {}

#variable "vnet_dns1" {}
#variable "vnet_dns2" {}

variable "vnet_tags" {
  type = "map"
}
