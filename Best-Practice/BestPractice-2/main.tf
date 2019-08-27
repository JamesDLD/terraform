#Set the terraform backend
terraform {
  required_version = ">= 0.12.6"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-2.0.12.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = ">= 1.31.0" #Use the last version tested through an Azure DevOps pipeline here : https://dev.azure.com/jamesdld23/vpc_lab/_build
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Call module/resource
#Get components
data "azurerm_resource_group" "bp2" {
  name = "infr-jdld-noprd-rg1"
}

#Action
module "Az-VirtualNetwork-demo" {
  source                      = "JamesDLD/Az-VirtualNetwork/azurerm"
  version                     = "0.1.1"
  net_prefix                  = "demo"
  network_resource_group_name = data.azurerm_resource_group.bp2.name
  virtual_networks = {
    vnet1 = {
      id            = "1"
      prefix        = "bp2"
      address_space = ["198.18.1.0/24", "198.18.2.0/24"]
    }
  }
  subnets                 = var.subnets
  route_tables            = {}
  network_security_groups = {}
}
