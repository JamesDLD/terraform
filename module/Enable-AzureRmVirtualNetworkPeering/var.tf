variable "vnet_src_name" {
}

variable "vnet_rg_src_name" {
}

variable "vnet_src_id" {
}

provider "azurerm" {
  alias = "src"
}

variable "Disable_Vnet_Peering" {
}

#############################################################
##########                  ops                    ##########
#############################################################
variable "list_one" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_one"
}

#############################################################
##########                  sec                    ##########
#############################################################
variable "list_two" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_two"
}

#############################################################
##########                  k8s                    ##########
#############################################################
variable "list_three" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_three"
}

#############################################################
##########               Agile Fabric              ##########
#############################################################
variable "list_four" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_four"
}

#############################################################
##########                   Pub                   ##########
#############################################################
variable "list_five" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_five"
}

#############################################################
##########                 Extra 1                 ##########
#############################################################
variable "list_six" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_six"
}

#############################################################
##########                 Extra 2                 ##########
#############################################################
variable "list_seven" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_seven"
}

#############################################################
##########                 Extra 3                 ##########
#############################################################
variable "list_eight" {
  description="Virtual network names and resource group names list."
  type = list(object({
    name                   = string
    resource_group_name    = number 
  }))
}

provider "azurerm" {
  alias = "provider_eight"
}

