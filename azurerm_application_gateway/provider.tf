#Set the terraform backend
terraform {
  backend "azurerm" {
    resource_group_name  = "infr-jdld-noprd-rg1"
    storage_account_name = "infrasdbx1vpcjdld1" #Name must be unique
    container_name       = "tfstate"
    key                  = "appgw.tfstate"
  }
  #required_version = "0.13.3"
}

#Set the Provider
provider "azurerm" {
  #version                    = "2.28.0"
  skip_provider_registration = true #(Optional) Should the AzureRM Provider skip registering the Resource Providers it supports? This can also be sourced from the ARM_SKIP_PROVIDER_REGISTRATION Environment Variable. Defaults to false.
  features {}

  #subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id

}
