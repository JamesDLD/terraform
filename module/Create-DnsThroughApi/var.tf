variable "Vms" {
  type = "list"
}

variable "Lbs" {
  type = "list"
}

variable "Dns_Wan_Records" {
  type = "list"
}

variable "vm_prefix" {}
variable "lb_prefix" {}
variable "lb_suffix" {}
variable "dns_fqdn_api" {}
variable "dns_secret" {}
variable "dns_application_name" {}
variable "xpod_dns_zone_name" {}
variable "vpod_dns_zone_name" {}
variable "Dns_Wan_RecordsCount" {}
variable "Dns_Vms_RecordsCount" {}
variable "Dns_Lbs_RecordsCount" {}
