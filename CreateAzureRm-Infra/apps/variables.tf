#Variables declaration

#Authentication
terraform {
  backend "azurerm" {
  }
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
  type        = list
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
  type        = map(string)
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

variable "bck_rsv_name" {
  description = "Infra recovery services vault name."
}

#Subnet & Network Security group

variable "apps_snets" {
  type        = list
  description = "Subnet list."
}

variable "apps_nsgs" {
  type        = list
  description = "Apps Network Security Groups list containing the following keys : suffix_name."
}

variable "apps_nsgrules" {
  type        = list
  description = "Apps Network Security Groups Rules list."
}

variable "asgs" {
  type        = list
  description = "Application Security Groups list containing the following keys : suffix_name."
}

#Load Balancers & Availability Set & Virtual Machines
variable "Lb_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted values are Basic and Standard. Defaults to Basic."
}

variable "Lbs" {
  type        = list
  description = "Load Balancer list containing the following keys : suffix_name, Id_Subnet, static_ip."
}

variable "LbRules" {
  type        = list
  description = "Load Balancer rules list."
}

variable "Linux_Vms" {
  type        = list
  description = "Linux VM list"
}

variable "Linux_DataDisks" {
  type = list
}

variable "Linux_storage_image_reference" {
  type        = list
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "Windows_Vms" {
  type        = list
  description = "Windows VM list"
}

variable "Windows_DataDisks" {
  type = list
}

variable "Windows_storage_image_reference" {
  type        = list
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "Linux_Ss_Vms" {
  type        = list
  description = "Linux VM Scale Set list"
}

variable "Windows_Ss_Vms" {
  type        = list
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

