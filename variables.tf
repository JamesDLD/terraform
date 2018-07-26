#Variables declaration

#Authentication
terraform {
  backend          "azurerm"        {}
  required_version = "0.11.7"
}

provider "azurerm" {
  version = "1.8"
}

provider "random" {
  version = "1.3"
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

variable "policies" {
  type = "list"
}

variable "roles" {
  type = "list"
}

#Backup
variable "backup_policies" {
  type = "list"
}

#Vnet & Subnet & Network Security group
variable "vnets" {
  type = "list"
}

variable "apps_snets" {
  type = "list"
}

variable "route_tables" {
  type = "list"
}

variable "routes" {
  type = "list"
}

variable "infra_nsgs" {
  type = "list"
}

variable "infra_nsgrules" {
  type = "list"
}

variable "apps_nsgs" {
  type = "list"
}

variable "apps_nsgrules" {
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
variable "auto_sku" {}
