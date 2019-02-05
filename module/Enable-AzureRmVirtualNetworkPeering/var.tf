variable "vnet_src_name" {}
variable "vnet_rg_src_name" {}
variable "vnet_src_id" {}

provider "azurerm" {
  alias = "src"
}

variable "Disable_Vnet_Peering" {}

#############################################################
##########                  ops                    ##########
#############################################################
variable "list_one" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_one"
}

#############################################################
##########                  sec                    ##########
#############################################################
variable "list_two" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_two"
}

#############################################################
##########                  k8s                    ##########
#############################################################
variable "list_three" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_three"
}

#############################################################
##########               Agile Fabric              ##########
#############################################################
variable "list_four" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_four"
}

#############################################################
##########                   Pub                   ##########
#############################################################
variable "list_five" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_five"
}

#############################################################
##########                 Extra 1                 ##########
#############################################################
variable "list_six" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_six"
}

#############################################################
##########                 Extra 2                 ##########
#############################################################
variable "list_seven" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_seven"
}

#############################################################
##########                 Extra 3                 ##########
#############################################################
variable "list_eight" {
  type = "list"
}

provider "azurerm" {
  alias = "provider_eight"
}
