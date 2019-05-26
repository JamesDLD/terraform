# Providers (Infra & Apps)

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.service_principals[1]["Application_Id"]
  client_secret   = var.service_principals[1]["Application_Secret"]
  tenant_id       = var.tenant_id
  alias           = "service_principal_apps"
}

# Module

####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
  provider = azurerm.service_principal_apps
}

data "azurerm_storage_account" "Infr" {
  name                = var.sa_infr_name
  resource_group_name = var.rg_infr_name
  provider = azurerm.service_principal_apps
}

####################################################
##########              Apps              ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "MyApps" {
  name = var.rg_apps_name
  provider = azurerm.service_principal_apps
}

data "azurerm_route_table" "Infr" {
  name                = "jdld-infr-core-rt1"
  resource_group_name = data.azurerm_resource_group.Infr.name
  provider = azurerm.service_principal_apps
}

data "azurerm_network_security_group" "Infr" {
  name                = "jdld-infr-snet-apps-nsg1"
  resource_group_name = var.rg_infr_name
  provider = azurerm.service_principal_apps
}

## Core Network components
module "Az-NetworkSecurityGroup-Apps" {
  source                  = "../../module/Az-NetworkSecurityGroup"
  nsgs                    = var.apps_nsgs
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = data.azurerm_resource_group.MyApps.location
  nsg_resource_group_name = data.azurerm_resource_group.MyApps.name
  nsg_tags                = data.azurerm_resource_group.MyApps.tags
  nsgrules                = var.apps_nsgrules
    providers = {
    azurerm = azurerm.service_principal_apps
  }
}

module "Az-Subnet-Apps" {
  source                     = "../../module/Az-Subnet"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = var.rg_infr_name
  snet_list                  = var.apps_snets
  vnet_names                 = ["infra-jdld-infr-apps-net1"]
  nsgs_ids                   = [data.azurerm_network_security_group.Infr.id]
  route_table_ids            = [data.azurerm_route_table.Infr.id]
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

## Virtual Machines components

module "Az-LoadBalancer-Apps" {
  source                 = "../../module/Az-LoadBalancer"
  Lbs                    = var.Lbs
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = data.azurerm_resource_group.MyApps.location
  lb_resource_group_name = data.azurerm_resource_group.MyApps.name
  Lb_sku                 = var.Lb_sku
  subnets_ids            = module.Az-Subnet-Apps.subnets_ids
  lb_tags                = data.azurerm_resource_group.MyApps.tags
  LbRules                = var.LbRules
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

module "Az-NetworkInterface-Apps" {
  source                  = "../../module/Az-NetworkInterface"
  subscription_id         = var.subscription_id
  Linux_Vms               = var.Linux_Vms   #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = var.Windows_Vms #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "${var.app_name}-${var.env_name}-"
  nic_suffix              = "-nic1"
  nic_location            = data.azurerm_resource_group.MyApps.location
  nic_resource_group_name = data.azurerm_resource_group.MyApps.name
  subnets_ids             = module.Az-Subnet-Apps.subnets_ids
  lb_backend_ids          = module.Az-LoadBalancer-Apps.lb_backend_ids
  lb_backend_Public_ids   = ["null"]
  nic_tags                = data.azurerm_resource_group.MyApps.tags
  nsgs_ids                = module.Az-NetworkSecurityGroup-Apps.nsgs_ids
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

module "Az-Vm-Apps" {
  source                             = "../../module/Az-Vm"
  subscription_id                    = var.subscription_id
  sa_bootdiag_storage_uri            = data.azurerm_storage_account.Infr.primary_blob_endpoint
  key_vault_id                       = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""

  Linux_Vms                     = var.Linux_Vms #If no need just fill "Linux_Vms = []" in the tfvars file
  Linux_nics_ids                = module.Az-NetworkInterface-Apps.Linux_nics_ids
  Linux_storage_image_reference = var.Linux_storage_image_reference
  Linux_DataDisks               = var.Linux_DataDisks
  ssh_key                       = var.ssh_key

  Windows_Vms                     = var.Windows_Vms #If no need just fill "Windows_Vms = []" in the tfvars file
  Windows_nics_ids                = module.Az-NetworkInterface-Apps.Windows_nics_ids
  Windows_storage_image_reference = var.Windows_storage_image_reference #If no need just fill "Windows_storage_image_reference = []" in the tfvars file
  Windows_DataDisks               = var.Windows_DataDisks

  vm_location            = data.azurerm_resource_group.MyApps.location
  vm_resource_group_name = data.azurerm_resource_group.MyApps.name
  vm_prefix              = "${var.app_name}-${var.env_name}-"
  vm_tags                = data.azurerm_resource_group.MyApps.tags
  app_admin              = var.app_admin
  pass                   = var.pass
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

# Infra cross services for Apps
module "Az-RecoveryServicesBackupProtection-Apps" {
  source          = "../../module/Az-RecoveryServicesBackupProtection"
  subscription_id = var.subscription_id
  bck_vms_names = concat(
    module.Az-Vm-Apps.Linux_Vms_names,
    module.Az-Vm-Apps.Windows_Vms_names,
  ) #Names of the resources to backup
  bck_vms_resource_group_names = concat(
    module.Az-Vm-Apps.Linux_Vms_rgnames,
    module.Az-Vm-Apps.Windows_Vms_rgnames,
  ) #Resource Group Names of the resources to backup
  bck_vms                     = concat(var.Linux_Vms, var.Windows_Vms)
  bck_rsv_name                = var.bck_rsv_name
  bck_rsv_resource_group_name = data.azurerm_resource_group.Infr.name
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

## Infra common services
#N/A

