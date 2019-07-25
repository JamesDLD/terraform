#Variables declaration

#Authentication
terraform {
  backend "azurerm" {
  }
  required_version = "0.12.5"
}

provider "random" {
  version = "2.1.2"
}

variable "subscription_id" {
  description = "Azure subscription Id."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant Id."
  type        = string
}

variable "service_principals" {
  description = "Azure service principals list."
  type = list(object({
    Application_Name      = string
    Application_Id        = string
    Application_Secret    = string
    Application_object_id = string
  }))
}

#Common
variable "app_name" {
  description = "Application name used in objects naming convention."
  type        = string
}

variable "env_name" {
  description = "Environment name used in objects naming convention."
  type        = string
}

variable "default_tags" {
  type        = map(string)
  description = "Tag map that will be pushed on all Azure resources."
}

variable "rg_apps_name" {
  description = "Apps resource group name."
  type        = string
}

variable "rg_infr_name" {
  description = "infra resource group name."
  type        = string
}

variable "sa_infr_name" {
  description = "Infra storage account name."
  type        = string
}

variable "kv_sku" {
  description = "Key vault sku."
  type        = string
}

variable "key_vaults" {
  description = "List containing your key vaults."
  type = list(object({
    suffix_name            = string
    policy1_tenant_id      = string
    policy1_object_id      = string
    policy1_application_id = string
  }))
}

variable "policies" {
  description = "Policies."
  type = list(object({
    suffix_name = string #Used to name the policy and to call json template files located into the module's folder
    policy_type = string
    mode        = string
  }))
}

variable "roles" {
  description = "Roles list."
  type = list(object({
    suffix_name = string
    actions     = string
    not_actions = string
  }))
}

#Backup
variable "backup_policies" {
  description = "Recovery services vault backup policies."
  type = list(object({
    Name                          = string
    scheduleRunFrequency          = string
    scheduleRunDays               = string
    scheduleRunTimes              = string
    timeZone                      = string
    dailyRetentionDurationCount   = number
    weeklyRetentionDurationCount  = number
    monthlyRetentionDurationCount = number
  }))
}

#Vnet & Subnet & Network Security group
variable "vnets" {
  description = "Virtual Networks list."
  type        = any
}

variable "snets" {
  description = "Subnet list."
  type        = any
}

variable "route_tables" {
  description = "Route table."
  type        = any
}

variable "infra_nsgs" {
  type        = any
  description = "Infra Network Security Groups list containing the following keys : suffix_name."
}

#Compute
variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
  type        = string
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
  type        = string
}

variable "ssh_key" {
  description = "Specifies the ssh public key to login on Linux VM."
  type        = string
}
