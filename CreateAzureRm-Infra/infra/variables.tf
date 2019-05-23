#Variables declaration

#Authentication
terraform {
  backend          "azurerm"        {}
  required_version = "0.12.0"
}

provider "azurerm" {
  version = "1.27.1"
}

provider "random" {
  version = "2.1.2"
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

variable "rg_apps_name" {
  description = "Apps resource group name."
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

variable "snets" {
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
