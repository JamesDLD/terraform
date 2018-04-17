#Variables declaration

#Authentication
variable "subscription_id" {}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "app_name" {}
variable "env_name" {}
variable "location" {}

variable "default_tags" {
  type = "map"
}

#Common
variable "sa_account_replication_type" {}

variable "sa_account_tier" {}
variable "rg_apps_name" {}
variable "sa_apps_name" {}
variable "rg_infr_name" {}
variable "sa_infr_name" {}

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

variable "subnet_nsgrules" {
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

variable "app_admin" {
  default = "TO BE REPLACED"
}

variable "pass" {
  default = "TO BE REPLACED"
}

variable "ssh_key" {
  default = "ssh-rsa TO BE REPLACED"
}
