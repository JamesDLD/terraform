variable "subnet_resource_group_name" {}

variable "vnets" {
  type = "list"
}

variable "subnet_prefix" {}
variable "subnet_suffix" {}

variable "snets" {
  type = "list"
}

variable "subnet_route_table_ids" {
  type = "list"
}

variable "nsgs_ids" {
  type = "list"
}
