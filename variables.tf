#Variables declaration

#Authentication
terraform {
  backend "azurerm" {}
}

variable "subscription_id" {}
variable "tenant_id" {}

variable "service_principals" {
  type = "list"
}

#Common
variable "app_name" {}

variable "env_name" {}

variable "default_tags" {
  type = "map"
}

variable "sa_account_replication_type" {}
variable "sa_account_tier" {}
variable "rg_apps_name" {}
variable "sa_apps_name" {}
variable "rg_infr_name" {}
variable "sa_infr_name" {}
variable "kv_sku" {}

variable "key_vaults" {
  type = "list"
}

#Backup
variable "backup_policies" {
  type = "list"
}

#Vnet & Subnet & Network Security group
variable "vnet_apps_address_space" {}

variable "apps_snets" {
  type = "list"
}

variable "default_routes" {
  type = "list"
}

variable "nsgs" {
  type = "list"
}

variable "nsgrules" {
  type = "list"
}

variable "asgs" {
  type = "list"
}

#Load Balancers & Availability Set & Virtual Machines
variable "Lb_sku" {}

variable "Lbs" {
  type = "list"
}

variable "LbRules" {
  type = "list"
}

variable "Availabilitysets" {
  type = "list"
}

variable "Linux_Vms" {
  type = "list"
}

variable "Windows_Vms" {
  type = "list"
}

variable "Linux_Ss_Vms" {
  type = "list"
}

variable "Windows_Ss_Vms" {
  type = "list"
}

variable "app_admin" {}
variable "pass" {}
variable "ssh_key" {}
variable "dns_fqdn_api" {}
variable "dns_secret" {}
variable "dns_application_name" {}
variable "xpod_dns_zone_name" {}
variable "Dns_Wan_RecordsCount" {}
variable "Dns_Vms_RecordsCount" {}
variable "Dns_Lbs_RecordsCount" {}
variable "vpod_dns_zone_name" {}

variable "Dns_Wan_Records" {
  type = "list"
}

variable "auto_sku" {}
