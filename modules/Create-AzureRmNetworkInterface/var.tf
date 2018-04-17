variable "Linux_Vms" {
  type = "list"
}

variable "Windows_Vms" {
  type = "list"
}

variable "nic_suffix" {}
variable "nic_prefix" {}
variable "nic_location" {}
variable "nic_resource_group_name" {}

variable "subnets_ids" {
  type = "list"
}

variable "lb_backend_ids" {
  type = "list"
}

variable "nic_tags" {
  type = "map"
}
