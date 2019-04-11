#Set the terraform backend
terraform {
  required_version = "0.11.10"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-2.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "1.21"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

#Call module/resource
#Get components
module "Get-AzureRmVirtualNetwork" {
  version                  = "~> 0.1"
  source                   = "github.com/JamesDLD/terraform/module/Get-AzureRmVirtualNetwork"
  vnets                    = ["bp1-vnet1"]
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
}

module "Get-AzureRmResourceGroup" {
  version = "~> 0.1"
  source  = "github.com/JamesDLD/terraform/module/Get-AzureRmResourceGroup"
  rg_name = "infr-jdld-noprd-rg1"
}

#Action
module "Create-AzureRmSubnet" {
  source                     = "github.com/JamesDLD/terraform/module/Create-AzureRmSubnet"
  subscription_id            = "${var.subscription_id}"
  subnet_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  snet_list                  = ["${var.subnets}"]
  vnet_names                 = "${module.Get-AzureRmVirtualNetwork.vnet_names}"
  nsgs_ids                   = ["null"]
  subnet_route_table_ids     = ["null"]
}
