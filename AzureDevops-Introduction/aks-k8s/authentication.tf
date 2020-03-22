#Set the terraform backend
terraform {
  required_version = ">= 0.12.6"

  backend "azurerm" {} #Backend variables are initialized through the secret and variable folders
}

#Set the Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  version         = "~> 2.0"
  features {}
}

provider "azuread" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  #version         = "0.4.0"
  #Use the last version of the azurerm provider, reguraly tested by the following Azure DevOps pipeline : https://dev.azure.com/jamesdld23/vpc_lab/_build?definitionId=9&_a=summary
}

#Get the Resource Group and the SPN Id

data "azurerm_resource_group" "Infr" {
  name = "${var.rg_infr_name}"
}

data "azuread_service_principal" "Infr" {
  application_id = "${var.client_id}"
}
