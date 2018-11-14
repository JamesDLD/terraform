#Set the terraform backend
terraform {
  required_version = "0.11.8"

  backend "azurerm" {
    storage_account_name = "infrsand1vpodjdlddiagsa1"
    container_name       = "tfstate"
    key                  = "BestPractice-3.tfstate"
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

module "Get-AzureRmStorageAccount" {
  version    = "~> 0.1"
  source     = "github.com/JamesDLD/terraform/module/Get-AzureRmStorageAccount"
  sa_rg_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  sa_name    = "infrsand1vpodjdlddiagsa1"
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

module "Create-AzureRmLoadBalancer" {
  version                = "~> 0.1"
  source                 = "github.com/JamesDLD/terraform/module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "bp3-"
  lb_suffix              = "-lb1"
  lb_location            = "${module.Get-AzureRmResourceGroup.rg_location}"
  lb_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  Lb_sku                 = "Standard"
  subnets_ids            = "${module.Create-AzureRmSubnet.subnets_ids}"
  lb_tags                = "${module.Get-AzureRmResourceGroup.rg_tags}"
  LbRules                = []
}

module "Create-AzureRmNetworkInterface" {
  version                 = "~> 0.1"
  source                  = "github.com/JamesDLD/terraform/module/Create-AzureRmNetworkInterface"
  Linux_Vms               = []                                                                    #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                                #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "bp3-"
  nic_suffix              = "-nic1"
  nic_location            = "${module.Get-AzureRmResourceGroup.rg_location}"
  nic_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  subnets_ids             = "${module.Create-AzureRmSubnet.subnets_ids}"
  nic_tags                = "${module.Get-AzureRmResourceGroup.rg_tags}"
  nsgs_ids                = [""]

  #This an implicit dependency
  lb_backend_ids = "${module.Create-AzureRmLoadBalancer.lb_backend_ids}"

  #This an explicit dependency                 
  #lb_backend_ids = ["/subscriptions/${var.subscription_id}/resourceGroups/infr-jdld-noprd-rg1/providers/Microsoft.Network/loadBalancers/bp3-internal-lb1/backendAddressPools/bp3-internal-bckpool1"]
}
