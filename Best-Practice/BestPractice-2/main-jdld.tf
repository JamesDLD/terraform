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
  source                   = "../../module/Get-AzureRmVirtualNetwork"
  vnets                    = ["virtualNetwork1"]
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
}

module "Get-AzureRmResourceGroup" {
  source  = "../../module/Get-AzureRmResourceGroup"
  rg_name = "infr-jdld-noprd-rg1"
}

module "Get-AzureRmStorageAccount" {
  source     = "../../module/Get-AzureRmStorageAccount"
  sa_rg_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  sa_name    = "infrsand1vpodjdlddiagsa1"
}

#Action
module "Create-AzureRmSubnet" {
  source                     = "../../module/Create-AzureRmSubnet"
  subnet_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  subnet_prefix              = "demo-"
  subnet_suffix              = "-snet1"
  snets                      = ["${var.subnets}"]
  vnets                      = "${module.Get-AzureRmVirtualNetwork.vnet_names}"
  nsgs_ids                   = ["null"]
  subnet_route_table_ids     = ["null"]
}

/*
module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "../../module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${module.Get-AzureRmResourceGroup.rg_location}"
  lb_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${module.Create-AzureRmSubnet.subnets_ids}"
  lb_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
  LbRules                = ["${var.LbRules}"]
}


module "Create-AzureRmVm-Apps" {
  source                  = "../../module/Create-AzureRmVm"
  sa_bootdiag_storage_uri = "${module.Create-AzureRmStorageAccount-Apps.sa_primary_blob_endpoint}"
  Linux_Vms               = [""]                                                                   #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                                 #If no need just fill "Windows_Vms = []" in the tfvars file
  vm_location             = "${module.Get-AzureRmResourceGroup.rg_location}"
  vm_resource_group_name  = "${module.Get-AzureRmResourceGroup.rg_name}"
  vm_prefix               = "demo-"
  vm_tags                 = "${module.Get-AzureRmResourceGroup.rg_tags}"
  app_admin               = "${var.app_admin}"
  pass                    = "${var.pass}"
  ssh_key                 = "${var.ssh_key}"
  ava_set_ids             = "${module.Create-AzureRmAvailabilitySet-Apps.ava_set_ids}"
  Linux_nics_ids          = "${module.Create-AzureRmNetworkInterface-Apps.Linux_nics_ids}"
  Windows_nics_ids        = "${module.Create-AzureRmNetworkInterface-Apps.Windows_nics_ids}"
}
*/

