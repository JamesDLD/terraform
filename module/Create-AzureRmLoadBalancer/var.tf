variable "Lbs" {
  type = "list"
}

variable "lb_prefix" {}
variable "lb_suffix" {}
variable "lb_location" {}
variable "lb_resource_group_name" {}
variable "Lb_sku" {}

variable "subnets_ids" {
  type = "list"
}

variable "lb_tags" {
  type = "map"
}

variable "LbRules" {
  type = "list"
}
