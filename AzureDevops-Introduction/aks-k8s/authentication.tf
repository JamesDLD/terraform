#Set the terraform backend
terraform {
  required_version = ">= 0.12"

  backend "azurerm" {} #Backend variables are initialized through the secret and variable folders
}

#Set the Provider
provider "azurerm" {
  version         = "1.29.0"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

provider "azuread" {
  version         = "0.3.1"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

#Get the Resource Group and the SPN Id

data "azurerm_resource_group" "Infr" {
  name = "${var.rg_infr_name}"
}

data "azuread_service_principal" "Infr" {
  application_id = "${var.client_id}"
}
