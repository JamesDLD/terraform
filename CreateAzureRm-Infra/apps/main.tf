# Providers (Infra & Apps)

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${lookup(var.service_principals[1], "Application_Id")}"
  client_secret   = "${lookup(var.service_principals[1], "Application_Secret")}"
  tenant_id       = "${var.tenant_id}"
  version         = "1.21"
}

# Module

####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "Infr" {
  name = "${var.rg_infr_name}"
}

data "azurerm_storage_account" "Infr" {
  name                = "${var.sa_infr_name}"
  resource_group_name = "${var.rg_infr_name}"
}

####################################################
##########              Apps              ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "MyApps" {
  name = "${var.rg_apps_name}"
}

data "azurerm_route_table" "Infr" {
  name                = "jdld-infr-core-rt1"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
}

data "azurerm_network_security_group" "Infr" {
  name                = "jdld-infr-snet-apps-nsg1"
  resource_group_name = "${var.rg_infr_name}"
}

## Core Network components
module "Create-AzureRmNetworkSecurityGroup-Apps" {
  source                  = "../../module/Create-AzureRmNetworkSecurityGroup"
  nsgs                    = ["${var.apps_nsgs}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${data.azurerm_resource_group.MyApps.location}"
  nsg_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  nsg_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  nsgrules                = ["${var.apps_nsgrules}"]
}

module "Create-AzureRmApplicationkSecurityGroup-Apps" {
  source                  = "../../module/Create-AzureRmApplicationSecurityGroup"
  asgs                    = ["${var.asgs}"]
  asg_prefix              = "${var.app_name}-${var.env_name}-"
  asg_suffix              = "-asg1"
  asg_location            = "${data.azurerm_resource_group.MyApps.location}"
  asg_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  asg_tags                = "${data.azurerm_resource_group.MyApps.tags}"
}

module "Create-AzureRmSubnet-Apps" {
  source                     = "../../module/Create-AzureRmSubnet"
  subnet_resource_group_name = "${var.rg_infr_name}"
  subnet_prefix              = "${var.app_name}-${var.env_name}-"
  subnet_suffix              = "-snet1"
  snets                      = ["${var.apps_snets}"]
  vnets                      = ["infra-jdld-infr-apps-net1"]
  nsgs_ids                   = ["${data.azurerm_network_security_group.Infr.id}"]
  subnet_route_table_ids     = ["${data.azurerm_route_table.Infr.id}"]
}

## Virtual Machines components
module "Create-AzureRmAvailabilitySet-Apps" {
  source                  = "../../module/Create-AzureRmAvailabilitySet"
  ava_availabilitysets    = ["${var.Availabilitysets}"]
  ava_prefix              = "${var.app_name}-${var.env_name}-"
  ava_suffix              = "-avs1"
  ava_location            = "${data.azurerm_resource_group.MyApps.location}"
  ava_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  ava_tags                = "${data.azurerm_resource_group.MyApps.tags}"
}

module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "../../module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${data.azurerm_resource_group.MyApps.location}"
  lb_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  LbRules                = ["${var.LbRules}"]
}

module "Create-AzureRmNetworkInterface-Apps" {
  source                  = "../../module/Create-AzureRmNetworkInterface"
  Linux_Vms               = ["${var.Linux_Vms}"]                                         #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                       #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "${var.app_name}-${var.env_name}-"
  nic_suffix              = "-nic1"
  nic_location            = "${data.azurerm_resource_group.MyApps.location}"
  nic_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  subnets_ids             = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_backend_ids          = "${module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids}"
  lb_backend_Public_ids   = []
  nic_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  nsgs_ids                = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_ids}"
}

module "Create-AzureRmVm-Apps" {
  source                  = "../../module/Create-AzureRmVm"
  sa_bootdiag_storage_uri = "${data.azurerm_storage_account.Infr.primary_blob_endpoint}"

  Linux_Vms                     = ["${var.Linux_Vms}"]                                           #If no need just fill "Linux_Vms = []" in the tfvars file
  Linux_nics_ids                = "${module.Create-AzureRmNetworkInterface-Apps.Linux_nics_ids}"
  Linux_storage_image_reference = "${var.Linux_storage_image_reference}"
  Linux_DataDisks               = ["${var.Linux_DataDisks}"]
  ssh_key                       = "${var.ssh_key}"

  Windows_Vms                     = ["${var.Windows_Vms}"]                                           #If no need just fill "Windows_Vms = []" in the tfvars file
  Windows_nics_ids                = "${module.Create-AzureRmNetworkInterface-Apps.Windows_nics_ids}"
  Windows_storage_image_reference = "${var.Windows_storage_image_reference}"                         #If no need just fill "Windows_storage_image_reference = []" in the tfvars file
  Windows_DataDisks               = ["${var.Windows_DataDisks}"]

  vm_location            = "${data.azurerm_resource_group.MyApps.location}"
  vm_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  vm_prefix              = "${var.app_name}-${var.env_name}-"
  vm_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  app_admin              = "${var.app_admin}"
  pass                   = "${var.pass}"
}

/*
#Need improvment 1 : NEED MAJOR UPDATE to fit with AzureRM provider 1.21.0
module "Create-AzureRmVmss-Apps" {
  source                   = "../../module/Create-AzureRmVmss"
  sa_bootdiag_storage_uri  = "${data.azurerm_storage_account.Infr.primary_blob_endpoint}"
  Linux_Ss_Vms             = ["${var.Linux_Ss_Vms}"]                                                #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Ss_Vms           = ["${var.Windows_Ss_Vms}"]                                              #If no need just fill "Linux_Vms = []" in the tfvars file
  vmss_location            = "${data.azurerm_resource_group.MyApps.location}"
  vmss_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  vmss_prefix              = "${var.app_name}-${var.env_name}-"
  vmss_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  app_admin                = "${var.app_admin}"
  pass                     = "${var.pass}"
  ssh_key                  = "${var.ssh_key}"
  subnets_ids              = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_backend_ids           = "${module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids}"
  nsgs_ids                 = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_ids}"
}

#Need improvment 1 : NEED MAJOR UPDATE to use the native terraform resource
# Infra cross services for Apps
module "Enable-AzureRmRecoveryServicesBackupProtection-Apps" {
  source                      = "../../module/Enable-AzureRmRecoveryServicesBackupProtection"
  resource_names              = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_names,module.Create-AzureRmVm-Apps.Windows_Vms_names)}"     #Names of the resources to backup
  resource_group_names        = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_rgnames,module.Create-AzureRmVm-Apps.Windows_Vms_rgnames)}" #Resource Group Names of the resources to backup
  resource_ids                = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_ids,module.Create-AzureRmVm-Apps.Windows_Vms_ids)}"         #Ids of the resources to backup
  bck_rsv_name                = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_name}"
  bck_rsv_resource_group_name = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_rgname}"
  bck_ProtectedItemType       = "Microsoft.ClassicCompute/virtualMachines"
  bck_BackupPolicyName        = "BackupPolicy-Schedule1"
  bck_location                = "${data.azurerm_resource_group.Infr.location}"
}
*/

## Infra common services
module "Create-AzureRmAutomationAccount-Apps" {
  source                   = "../../module/Create-AzureRmAutomationAccount"
  auto_name                = "${var.app_name}-${var.env_name}-auto1"
  auto_location            = "${data.azurerm_resource_group.MyApps.location}"
  auto_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  auto_sku                 = "${var.auto_sku}"
  auto_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  auto_credentials         = ["${var.service_principals}"]                    #If no need just set to []
}
