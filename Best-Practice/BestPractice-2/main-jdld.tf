#Set the terraform backend
terraform {
  required_version = "0.11.8"

  backend "azurerm" {
    storage_account_name = "infrsand1vpodjdlddiagsa1"
    container_name       = "tfstate"
    key                  = "BestPractice-2.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "1.15"
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
  vnets                    = ["demo-vnet1"]
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
}

module "Get-AzureRmResourceGroup" {
  version = "~> 0.1"
  source  = "github.com/JamesDLD/terraform/module/Get-AzureRmResourceGroup"
  rg_name = "infr-jdld-noprd-rg1"
}

#Action
module "Create-AzureRmSubnet" {
  version                    = "~> 0.1"
  source                     = "github.com/JamesDLD/terraform/module/Create-AzureRmSubnet"
  subnet_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  subnet_prefix              = "bp2-"
  subnet_suffix              = "-snet1"
  snets                      = ["${var.subnets}"]
  vnets                      = "${module.Get-AzureRmVirtualNetwork.vnet_names}"
  nsgs_ids                   = ["null"]
  subnet_route_table_ids     = ["null"]
}
