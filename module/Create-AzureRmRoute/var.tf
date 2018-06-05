variable "subnet_resource_group_name" {}
variable "rt_name" {}
variable "rt_location" {}
variable "rt_resource_group_name" {}
variable "vnet_name" {}

variable "rt_tags" {
  type = "map"
}

variable "rt_routes" {
  type = "list"
}

variable "subnet_prefix" {}
variable "subnet_suffix" {}

variable "snets" {
  type = "list"
}

variable "nsgs_ids" {
  type = "list"
}
