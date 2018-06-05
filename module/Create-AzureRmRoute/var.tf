variable "route_tables" {
  type = "list"
}

variable "routes" {
  type = "list"
}

variable "rt_prefix" {}
variable "rt_suffix" {}
variable "rt_location" {}
variable "rt_resource_group_name" {}

variable "rt_tags" {
  type = "map"
}
