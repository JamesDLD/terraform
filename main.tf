# Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${lookup(var.service_principals[0], "Application_Id")}"
  client_secret   = "${lookup(var.service_principals[0], "Application_Secret")}"
  tenant_id       = "${var.tenant_id}"

  #alias           = "service_principal_apps"
  #alias issues raised here : https://github.com/terraform-providers/terraform-provider-azurerm/issues/1308
}

# Module
## Prerequisistes Inventory
module "Get-AzureRmResourceGroup-Infr" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${var.rg_infr_name}"
}

module "Get-AzureRmResourceGroup-Apps" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${var.rg_apps_name}"
}

## Core Infra components
module "Create-AzureRmStorageAccount-Infr" {
  source                      = "./module/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_infr_name}"
  sa_resource_group_name      = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  sa_location                 = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"
}

module "Create-AzureRmRecoveryServicesVault-Infr" {
  source                  = "./module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "infra-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  rsv_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]
}

module "Create-AzureRmRecoveryServicesVault-Apps" {
  source                  = "./module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "apps-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  rsv_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]
}

module "Create-AzureRmKeyVault-Infr" {
  source                 = "./module/Create-AzureRmKeyVault"
  key_vaults             = ["${var.key_vaults}"]
  kv_tenant_id           = "${var.tenant_id}"
  kv_prefix              = "${var.app_name}-${var.env_name}-"
  kv_suffix              = "-kv1"
  kv_location            = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  kv_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  kv_sku                 = "${var.kv_sku}"
  kv_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"
}

## Core Network components
module "Create-AzureRmVirtualNetwork-Infra" {
  source                   = "./module/Create-AzureRmVirtualNetwork"
  vnet_name                = "infra-${var.app_name}-${var.env_name}-net1"
  vnet_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  vnet_address_space       = "${var.vnet_apps_address_space}"
  vnet_location            = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  vnet_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"

  #vnet_dns1                = "not used in this sample"
  #vnet_dns2                = "not used in this sample"
}

module "Create-AzureRmNetworkSecurityGroup-Apps" {
  source                  = "./module/Create-AzureRmNetworkSecurityGroup"
  nsgs                    = ["${var.nsgs}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  nsg_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  nsg_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  nsgrules                = ["${var.nsgrules}"]
}

module "Create-AzureRmApplicationkSecurityGroup-Apps" {
  source                  = "./module/Create-AzureRmApplicationSecurityGroup"
  asgs                    = ["${var.asgs}"]
  asg_prefix              = "${var.app_name}-${var.env_name}-"
  asg_suffix              = "-asg1"
  asg_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  asg_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  asg_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
}

module "Create-AzureRmSubnet-Apps" {
  source                     = "./module/Create-AzureRmSubnet"
  subnet_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  rt_name                    = "${var.app_name}-${var.env_name}-rt1"
  rt_location                = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  rt_resource_group_name     = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  rt_tags                    = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  rt_routes                  = ["${var.default_routes}"]
  subnet_prefix              = "${var.app_name}-${var.env_name}-"
  subnet_suffix              = "-snet1"
  snets                      = ["${var.apps_snets}"]
  vnet_name                  = "${module.Create-AzureRmVirtualNetwork-Infra.vnet_name}"
  nsgs_ids                   = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_ids}"
}

## Virtual Machines components
module "Create-AzureRmAvailabilitySet-Apps" {
  source                  = "./module/Create-AzureRmAvailabilitySet"
  ava_availabilitysets    = ["${var.Availabilitysets}"]
  ava_prefix              = "${var.app_name}-${var.env_name}-"
  ava_suffix              = "-avs1"
  ava_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  ava_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  ava_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
}

module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "./module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  lb_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  LbRules                = ["${var.LbRules}"]
}

module "Create-AzureRmNetworkInterface-Apps" {
  source                  = "./module/Create-AzureRmNetworkInterface"
  Linux_Vms               = ["${var.Linux_Vms}"]                                         #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                       #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "${var.app_name}-${var.env_name}-"
  nic_suffix              = "-nic1"
  nic_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  nic_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  subnets_ids             = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_backend_ids          = "${module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids}"
  nic_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  nsgs_ids                = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_ids}"
}

module "Create-AzureRmVm-Apps" {
  source                  = "./module/Create-AzureRmVm"
  sa_bootdiag_storage_uri = "${module.Create-AzureRmStorageAccount-Infr.sa_primary_blob_endpoint}"
  Linux_Vms               = ["${var.Linux_Vms}"]                                                   #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                                 #If no need just fill "Windows_Vms = []" in the tfvars file
  vm_location             = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  vm_resource_group_name  = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  vm_prefix               = "${var.app_name}-${var.env_name}-"
  vm_tags                 = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  app_admin               = "${var.app_admin}"
  pass                    = "${var.pass}"
  ssh_key                 = "${var.ssh_key}"
  ava_set_ids             = "${module.Create-AzureRmAvailabilitySet-Apps.ava_set_ids}"
  Linux_nics_ids          = "${module.Create-AzureRmNetworkInterface-Apps.Linux_nics_ids}"
  Windows_nics_ids        = "${module.Create-AzureRmNetworkInterface-Apps.Windows_nics_ids}"
}

module "Create-AzureRmVmss-Apps" {
  source                   = "./module/Create-AzureRmVmss"
  sa_bootdiag_storage_uri  = "${module.Create-AzureRmStorageAccount-Infr.sa_primary_blob_endpoint}"
  Linux_Ss_Vms             = ["${var.Linux_Ss_Vms}"]                                                #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Ss_Vms           = ["${var.Windows_Ss_Vms}"]                                              #If no need just fill "Linux_Vms = []" in the tfvars file
  vmss_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  vmss_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  vmss_prefix              = "${var.app_name}-${var.env_name}-"
  vmss_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  app_admin                = "${var.app_admin}"
  pass                     = "${var.pass}"
  ssh_key                  = "${var.ssh_key}"
  subnets_ids              = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_backend_ids           = "${module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids}"
  nsgs_ids                 = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_ids}"
}

module "Enable-AzureRmRecoveryServicesBackupProtection-Apps" {
  source                      = "./module/Enable-AzureRmRecoveryServicesBackupProtection"
  resource_names              = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_names,module.Create-AzureRmVm-Apps.Windows_Vms_names)}"     #Names of the resources to backup
  resource_group_names        = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_rgnames,module.Create-AzureRmVm-Apps.Windows_Vms_rgnames)}" #Resource Group Names of the resources to backup
  resource_ids                = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_ids,module.Create-AzureRmVm-Apps.Windows_Vms_ids)}"         #Ids of the resources to backup
  bck_rsv_name                = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_name}"
  bck_rsv_resource_group_name = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_rgname}"
  bck_ProtectedItemType       = "Microsoft.ClassicCompute/virtualMachines"
  bck_BackupPolicyName        = "BackupPolicy-Schedule1"
  bck_location                = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
}

## Custom API
module "Create-DnsThroughApi" {
  source               = "./module/Create-DnsThroughApi"
  dns_fqdn_api         = "${var.dns_fqdn_api}"
  dns_secret           = "${var.dns_secret}"
  dns_application_name = "${var.dns_application_name}"
  xpod_dns_zone_name   = "${var.xpod_dns_zone_name}"
  vpod_dns_zone_name   = "${var.vpod_dns_zone_name}"

  Dns_Wan_RecordsCount = "${var.Dns_Wan_RecordsCount}" #If no need just set to "0"
  Dns_Wan_Records      = ["${var.Dns_Wan_Records}"]    #If no need just set to []

  vm_prefix            = "${var.app_name}-${var.env_name}-"
  Dns_Vms_RecordsCount = "${var.Dns_Vms_RecordsCount}"                #If no need just set to "0"
  Vms                  = ["${concat(var.Linux_Vms,var.Windows_Vms)}"] #If no need just set to []

  lb_suffix            = "-lb1"
  lb_prefix            = "${var.app_name}-${var.env_name}-"
  Dns_Lbs_RecordsCount = "${var.Dns_Lbs_RecordsCount}"      #If no need just set to "0"
  Lbs                  = ["${var.Lbs}"]                     #If no need just set to []
}

## Infra common services
module "Create-AzureRmAutomationAccount-Apps" {
  source                   = "./module/Create-AzureRmAutomationAccount"
  auto_name                = "${var.app_name}-${var.env_name}-auto1"
  auto_location            = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  auto_resource_group_name = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  auto_sku                 = "${var.auto_sku}"
  auto_tags                = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
  auto_credentials         = ["${var.service_principals}"]                         #If no need just set to []
}
