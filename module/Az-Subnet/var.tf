variable "subscription_id" {}
variable "subnet_resource_group_name" {type=string}

variable "vnet_names" {
  type = "list"
}

variable "snet_list" {
  type = "list"
}

variable "route_table_ids" {
  type = "list"
}

variable "nsgs_ids" {
  type = "list"
}
