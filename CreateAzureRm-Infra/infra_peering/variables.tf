#Variables declaration

#Authentication
terraform {
  backend "azurerm" {
  }
  required_version = ">= 0.12.6"
}

provider "azurerm" {
  version = ">= 1.31.0" #Use the last version tested through an Azure DevOps pipeline here : https://dev.azure.com/jamesdld23/vpc_lab/_build
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
  type        = list
  description = "Azure service principals list containing the following keys : Application_Name, Application_Id, Application_Secret, Application_object_id."
}

#Common

variable "rg_infr_name" {
  description = "infra resource group name."
}

#Vnet 
variable "vnet_names" {
  type        = list(string)
  description = "Virtual Network Names list."
}

#Compute
variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
}

variable "ssh_key" {
  description = "Specifies the ssh public key to login on Linux VM."
}

variable "key_vaults" {
  type        = list
  description = "Azure Key vault list containing the following keys : suffix_name, policy1_tenant_id, policy1_object_id, policy1_application_id."
}

