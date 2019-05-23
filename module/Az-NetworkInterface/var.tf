provider "null" {
  version = "2.1.2"
}

variable "subscription_id" {}

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

variable "lb_backend_Public_ids" {
  type = "list"
}

variable "nic_tags" {
  type = "map"
}

variable "nsgs_ids" {
  type = "list"
}

variable "use_old_ip_configuration_name" {
  default     = "false"
  description = "Only used by the vpod team for retro compatibility with old model"
}
