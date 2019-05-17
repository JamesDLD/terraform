provider "null" {
  version = "2.1.2"
}

variable "subscription_id" {}

variable "bck_vms_resource_group_names" {
  type = "list"
}

variable "bck_vms_names" {
  type = "list"
}

variable "bck_vms" {
  type = "list"
}

variable "bck_rsv_name" {}
variable "bck_rsv_resource_group_name" {}
