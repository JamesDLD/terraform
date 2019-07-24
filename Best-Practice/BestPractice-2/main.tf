#Set the terraform backend
terraform {
  required_version = "0.12.5"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-2.0.12.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "1.31.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Call module/resource
#Get components
module "Get-AzureRmVirtualNetwork" {
  #version                  = "~> 0.1"
  source                   = "git::https://github.com/JamesDLD/terraform.git//module/Get-AzureRmVirtualNetwork?ref=master"
  vnets                    = ["bp1-vnet1"]
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
}

data "azurerm_resource_group" "infr" {
  name = "infr-jdld-noprd-rg1"
}

#Action
resource "azurerm_subnet" "DemoBP2" {
  count                = length(var.subnets)
  name                 = var.subnets[count.index]["name"]
  resource_group_name  = data.azurerm_resource_group.infr.name
  virtual_network_name = element(module.Get-AzureRmVirtualNetwork.vnet_names, var.subnets[count.index]["vnet_name_id"])
  address_prefix       = var.subnets[count.index]["cidr_block"]
  service_endpoints    = lookup(var.subnets[count.index], "service_endpoints", null)
}
