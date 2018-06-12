variable "vnets" {
  type = "list"
}

variable "vnet_prefix" {}
variable "vnet_suffix" {}
variable "vnet_resource_group_name" {}
variable "vnet_location" {}

variable "vnet_tags" {
  type = "map"
}
