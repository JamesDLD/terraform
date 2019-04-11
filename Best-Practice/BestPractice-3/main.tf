#Set the terraform backend
terraform {
  required_version = "0.11.10"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-3.tfstate"
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
  source                   = "github.com/JamesDLD/terraform/module/Get-AzureRmVirtualNetwork"
  vnets                    = ["bp1-vnet1"]
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
}

module "Get-AzureRmResourceGroup" {
  source  = "github.com/JamesDLD/terraform/module/Get-AzureRmResourceGroup"
  rg_name = "infr-jdld-noprd-rg1"
}

module "Get-AzureRmStorageAccount" {
  source     = "github.com/JamesDLD/terraform/module/Get-AzureRmStorageAccount"
  sa_rg_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  sa_name    = "infrsand1vpcjdld1"
}

#Action
module "Create-AzureRmSubnet" {
  source                     = "github.com/JamesDLD/terraform/module/Az-Subnet"
  subscription_id            = "${var.subscription_id}"
  subnet_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  snet_list                  = ["${var.subnets}"]
  vnet_names                 = "${module.Get-AzureRmVirtualNetwork.vnet_names}"
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]
}

module "Create-AzureRmLoadBalancer" {
  source                 = "github.com/JamesDLD/terraform/module/Az-LoadBalancer"
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
  source                  = "github.com/JamesDLD/terraform/module/Az-NetworkInterface"
  subscription_id         = "${var.subscription_id}"
  Linux_Vms               = []                                                         #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                     #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "bp3-"
  nic_suffix              = "-nic1"
  nic_location            = "${module.Get-AzureRmResourceGroup.rg_location}"
  nic_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  subnets_ids             = "${module.Create-AzureRmSubnet.subnets_ids}"
  lb_backend_ids          = "${module.Create-AzureRmLoadBalancer.lb_backend_ids}"
  lb_backend_Public_ids   = ["null"]
  nic_tags                = "${module.Get-AzureRmResourceGroup.rg_tags}"
  nsgs_ids                = [""]
}

module "Create-AzureRmVms" {
  source                             = "github.com/JamesDLD/terraform/module/Az-Vm"
  subscription_id                    = "${var.subscription_id}"
  sa_bootdiag_storage_uri            = "${module.Get-AzureRmStorageAccount.sa_primary_blob_endpoint}"
  key_vault_id                       = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""

  Linux_Vms                     = [] #If no need just fill "Linux_Vms = []" in the tfvars file
  Linux_nics_ids                = []
  Linux_storage_image_reference = []
  Linux_DataDisks               = []
  ssh_key                       = ""

  Windows_Vms                     = ["${var.Windows_Vms}"]                                      #If no need just fill "Windows_Vms = []" in the tfvars file
  Windows_nics_ids                = "${module.Create-AzureRmNetworkInterface.Windows_nics_ids}"
  Windows_storage_image_reference = "${var.Windows_storage_image_reference}"                    #If no need just fill "Windows_storage_image_reference = []" in the tfvars file
  Windows_DataDisks               = []

  vm_location            = "${module.Get-AzureRmResourceGroup.rg_location}"
  vm_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  vm_prefix              = "bp3-"
  vm_tags                = "${module.Get-AzureRmResourceGroup.rg_tags}"
  app_admin              = "${var.app_admin}"
  pass                   = "${var.pass}"

  Linux_nics_ids = []
}
