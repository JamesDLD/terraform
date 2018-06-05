variable "Dns_Wan_Records" {
  type = "list"
}

variable "dns_fqdn_api" {}
variable "dns_secret" {}
variable "dns_application_name" {}
variable "xpod_dns_zone_name" {}
variable "vpod_dns_zone_name" {}
variable "Dns_Wan_RecordsCount" {}
variable "Dns_Host_RecordsCount" {}

variable "Dns_Hostnames" {
  type = "list"
}

variable "Dns_Ips" {
  type = "list"
}
