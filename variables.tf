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

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "service_principals" {
  type        = "list"
  description = "Azure service principals list containing the following keys : Application_Name, Application_Id, Application_Secret, Application_object_id."
}

#Common
variable "app_name" {
  description = "Application name used in objects naming convention."
}

variable "env_name" {
  description = "Environment name used in objects naming convention."
}

variable "default_tags" {
  type        = "map"
  description = "Tag map that will be pushed on all Azure resources."
}

variable "sa_account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
}

variable "sa_account_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "rg_apps_name" {
  description = "Apps resource group name."
}

variable "sa_apps_name" {
  description = "Apps storage account name."
}

variable "rg_infr_name" {
  description = "infra resource group name."
}

variable "sa_infr_name" {
  description = "Infra storage account name."
}

variable "kv_sku" {
  description = "An SKU block as described below."
}

variable "key_vaults" {
  type        = "list"
  description = "Azure Key vault list containing the following keys : suffix_name, policy1_tenant_id, policy1_object_id, policy1_application_id."
}

variable "policies" {
  type        = "list"
  description = "Azure Policy list containing the following keys : suffix_name, policy_type, mode."
}

variable "roles" {
  type        = "list"
  description = "Azure Custom role list containing the following keys : suffix_name, actions, not_actions."
}

#Backup
variable "backup_policies" {
  type        = "list"
  description = "Azure Recovery Services Vault policies list."
}

#Vnet & Subnet & Network Security group
variable "vnets" {
  type        = "list"
  description = "Virtual Network list."
}

variable "apps_snets" {
  type        = "list"
  description = "Subnet list."
}

variable "route_tables" {
  type        = "list"
  description = "Route table list containing the following keys : route_suffix_name."
}

variable "routes" {
  type        = "list"
  description = "Route list containing the following keys : name, Id_rt, address_prefix, next_hop_type, next_hop_in_ip_address."
}

variable "infra_nsgs" {
  type        = "list"
  description = "Infra Network Security Groups list containing the following keys : suffix_name."
}

variable "infra_nsgrules" {
  type        = "list"
  description = "Infra Network Security Groups Rules list."
}

variable "apps_nsgs" {
  type        = "list"
  description = "Apps Network Security Groups list containing the following keys : suffix_name."
}

variable "apps_nsgrules" {
  type        = "list"
  description = "Apps Network Security Groups Rules list."
}

variable "asgs" {
  type        = "list"
  description = "Application Security Groups list containing the following keys : suffix_name."
}

#Load Balancers & Availability Set & Virtual Machines
variable "Lb_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. Defaults to Basic."
}

variable "Lbs" {
  type        = "list"
  description = "Load Balancer list containing the following keys : suffix_name, Id_Subnet, static_ip."
}

variable "LbRules" {
  type        = "list"
  description = "Load Balancer rules list."
}

variable "Availabilitysets" {
  type        = "list"
  description = "Availability Set list containing the following keys : suffix_name."
}

variable "Linux_Vms" {
  type        = "list"
  description = "Linux VM list"
}

variable "Windows_Vms" {
  type        = "list"
  description = "Windows VM list"
}

variable "Linux_Ss_Vms" {
  type        = "list"
  description = "Linux VM Scale Set list"
}

variable "Windows_Ss_Vms" {
  type        = "list"
  description = "Windows VM Scale Set list"
}

variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
}

variable "ssh_key" {
  description = "Specifies the ssh public key to login on Linux VM."
}

variable "auto_sku" {
  description = "Specifies the automation account SKU."
}
