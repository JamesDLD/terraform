variable "app_admin" {}
variable "pass" {}
variable "ssh_key" {}
variable "vmss_prefix" {}
variable "vmss_location" {}
variable "vmss_resource_group_name" {}
variable "sa_bootdiag_storage_uri" {}

variable "Linux_Ss_Vms" {
  type = "list"
}

variable "Windows_Ss_Vms" {
  type = "list"
}

variable "subnets_ids" {
  type = "list"
}

variable "lb_backend_ids" {
  type = "list"
}

variable "vmss_tags" {
  type = "map"
}

variable "nsgs_ids" {
  type = "list"
}
