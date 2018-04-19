/*
With your Terraform template created, the first step is to initialize Terraform. 
This step ensures that Terraform has all the prerequisites to build your template in Azure.
==> 
terraform init

The next step is to have Terraform review and validate the template. 
This step compares the requested resources to the state information saved by Terraform and then outputs the planned execution. Resources are not created in Azure.
==>
terraform plan -var-file="main-jdld-sand1.tfvars"
*/

# Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Module
## Core Infra components
module "Create-AzureRmStorageAccount-Apps" {
  source                      = "./modules/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_apps_name}"
  sa_resource_group_name      = "${var.rg_apps_name}"
  sa_location                 = "${var.location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${var.default_tags}"
}

module "Create-AzureRmStorageAccount-Infr" {
  source                      = "./modules/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_infr_name}"
  sa_resource_group_name      = "${var.rg_infr_name}"
  sa_location                 = "${var.location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${var.default_tags}"
}

module "Create-AzureRmRecoveryServicesVault-Infr" {
  source                  = "./modules/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "apps-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${var.rg_infr_name}"
  rsv_tags                = "${var.default_tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]
}

## Core Network components
module "Create-AzureRmVirtualNetwork-Apps" {
  source                   = "./modules/Create-AzureRmVirtualNetwork"
  vnet_name                = "apps-${var.app_name}-${var.env_name}-net1"
  vnet_resource_group_name = "${var.rg_infr_name}"
  vnet_address_space       = "${var.vnet_apps_address_space}"
  vnet_location            = "${var.location}"
  vnet_tags                = "${var.default_tags}"

  #vnet_dns1                = "not used in this sample"
  #vnet_dns2                = "not used in this sample"
}

module "Create-AzureRmNetworkSecurityGroup-Apps" {
  source                  = "./modules/Create-AzureRmNetworkSecurityGroup"
  snets                   = ["${var.apps_snets}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${var.location}"
  nsg_resource_group_name = "${var.rg_apps_name}"
  nsg_tags                = "${var.default_tags}"
  nsgrules                = ["${var.subnet_nsgrules}"]
}

module "Create-AzureRmSubnet-Apps" {
  source                     = "./modules/Create-AzureRmSubnet"
  subnet_resource_group_name = "${var.rg_infr_name}"
  rt_name                    = "${var.app_name}-${var.env_name}-rt1"
  rt_location                = "${var.location}"
  rt_resource_group_name     = "${var.rg_apps_name}"
  rt_tags                    = "${var.default_tags}"
  rt_routes                  = ["${var.default_routes}"]
  subnet_prefix              = "${var.app_name}-${var.env_name}-"
  subnet_suffix              = "-snet1"
  snets                      = ["${var.apps_snets}"]
  vnet_name                  = "${module.Create-AzureRmVirtualNetwork-Apps.vnet_name}"
  subnet_nsgs_ids            = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_subnet_ids}"
}

## Virtual Machines components
module "Create-AzureRmAvailabilitySet-Apps" {
  source                  = "./modules/Create-AzureRmAvailabilitySet"
  ava_availabilitysets    = ["${var.Availabilitysets}"]
  ava_prefix              = "${var.app_name}-${var.env_name}-"
  ava_suffix              = "-avs1"
  ava_location            = "${var.location}"
  ava_resource_group_name = "${var.rg_apps_name}"
  ava_tags                = "${var.default_tags}"
}

module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "./modules/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${var.location}"
  lb_resource_group_name = "${var.rg_apps_name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_tags                = "${var.default_tags}"
  LbRules                = ["${var.LbRules}"]
}

module "Create-AzureRmNetworkInterface-Apps" {
  source                  = "./modules/Create-AzureRmNetworkInterface"
  Linux_Vms               = ["${var.Linux_Vms}"]                                       #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                     #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "${var.app_name}-${var.env_name}-"
  nic_suffix              = "-nic1"
  nic_location            = "${var.location}"
  nic_resource_group_name = "${var.rg_apps_name}"
  subnets_ids             = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_backend_ids          = "${module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids}"
  nic_tags                = "${var.default_tags}"
}

module "Create-AzureRmVm-Apps" {
  source                  = "./modules/Create-AzureRmVm"
  sa_bootdiag_storage_uri = "${module.Create-AzureRmStorageAccount-Infr.sa_primary_blob_endpoint}"
  Linux_Vms               = ["${var.Linux_Vms}"]                                                   #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                                 #If no need just fill "Windows_Vms = []" in the tfvars file
  vm_location             = "${var.location}"
  vm_resource_group_name  = "${var.rg_apps_name}"
  vm_prefix               = "${var.app_name}-${var.env_name}-"
  vm_tags                 = "${var.default_tags}"
  app_admin               = "${var.app_admin}"
  pass                    = "${var.pass}"
  ssh_key                 = "${var.ssh_key}"
  ava_set_ids             = "${module.Create-AzureRmAvailabilitySet-Apps.ava_set_ids}"
  Linux_nics_ids          = "${module.Create-AzureRmNetworkInterface-Apps.Linux_nics_ids}"
  Windows_nics_ids        = "${module.Create-AzureRmNetworkInterface-Apps.Windows_nics_ids}"
}

module "Enable-AzureRmRecoveryServicesBackupProtection-Apps" {
  source                      = "./modules/Enable-AzureRmRecoveryServicesBackupProtection"
  resource_names              = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_names,module.Create-AzureRmVm-Apps.Windows_Vms_names)}"     #Names of the resources to backup
  resource_group_names        = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_rgnames,module.Create-AzureRmVm-Apps.Windows_Vms_rgnames)}" #Resource Group Names of the resources to backup
  resource_ids                = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_ids,module.Create-AzureRmVm-Apps.Windows_Vms_ids)}"         #Ids of the resources to backup
  bck_rsv_name                = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_name}"
  bck_rsv_resource_group_name = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_rgname}"
  bck_ProtectedItemType       = "Microsoft.ClassicCompute/virtualMachines"
  bck_BackupPolicyName        = "BackupPolicy-Schedule1"
  bck_location                = "${var.location}"
}
