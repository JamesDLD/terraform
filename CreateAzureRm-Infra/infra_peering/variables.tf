#Variables declaration

#Authentication
terraform {
  backend          "azurerm"        {}
  required_version = "0.11.14"
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

variable "rg_infr_name" {
  description = "infra resource group name."
}

#Vnet 
variable "vnet_names" {
  type        = "list"
  description = "Virtual Network Names list."
}
