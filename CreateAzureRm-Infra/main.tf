# Providers (Infra & Apps)
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${lookup(var.service_principals[0], "Application_Id")}"
  client_secret   = "${lookup(var.service_principals[0], "Application_Secret")}"
  tenant_id       = "${var.tenant_id}"
  alias           = "service_principal_infra"
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${lookup(var.service_principals[1], "Application_Id")}"
  client_secret   = "${lookup(var.service_principals[1], "Application_Secret")}"
  tenant_id       = "${var.tenant_id}"
  alias           = "service_principal_apps"
}

# Module

####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "Infr" {
  name     = "${var.rg_infr_name}"
  provider = "azurerm.service_principal_infra"
}

data "azurerm_resource_group" "Apps" {
  name     = "${var.rg_apps_name}"
  provider = "azurerm.service_principal_infra"
}

## Core Infra components
module "Create-AzureRmRecoveryServicesVault-Infr" {
  source                  = "../module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "infra-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  rsv_tags                = "${data.azurerm_resource_group.Infr.tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmKeyVault-Infr" {
  source                 = "../module/Create-AzureRmKeyVault"
  key_vaults             = ["${var.key_vaults}"]
  kv_tenant_id           = "${var.tenant_id}"
  kv_prefix              = "${var.app_name}-${var.env_name}-"
  kv_suffix              = "-kv1"
  kv_location            = "${data.azurerm_resource_group.Infr.location}"
  kv_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  kv_sku                 = "${var.kv_sku}"
  kv_tags                = "${data.azurerm_resource_group.Infr.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

data "azurerm_storage_account" "Infr" {
  name                = "${var.sa_infr_name}"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  provider            = "azurerm.service_principal_infra"
}

## Core Network components
module "Create-AzureRmVirtualNetwork-Infra" {
  source                   = "../module/Create-AzureRmVirtualNetwork"
  vnets                    = ["${var.vnets}"]
  vnet_prefix              = "infra-${var.app_name}-${var.env_name}-"
  vnet_suffix              = "-net1"
  vnet_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  vnet_location            = "${data.azurerm_resource_group.Infr.location}"
  vnet_tags                = "${data.azurerm_resource_group.Infr.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmNetworkSecurityGroup-Infra" {
  source                  = "../module/Create-AzureRmNetworkSecurityGroup"
  nsgs                    = ["${var.infra_nsgs}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${data.azurerm_resource_group.Infr.location}"
  nsg_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  nsg_tags                = "${data.azurerm_resource_group.Infr.tags}"
  nsgrules                = ["${var.infra_nsgrules}"]

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmRoute-Infra" {
  source                 = "../module/Create-AzureRmRoute"
  rt_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  rt_location            = "${data.azurerm_resource_group.Infr.location}"
  routes                 = ["${var.routes}"]
  route_tables           = ["${var.route_tables}"]
  rt_prefix              = "${var.app_name}-${var.env_name}-"
  rt_suffix              = "-rt1"
  rt_tags                = "${data.azurerm_resource_group.Infr.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

## Secops policies & RBAC roles
module "Create-AzureRmPolicyDefinition" {
  source     = "../module/Create-AzureRmPolicyDefinition"
  policies   = ["${var.policies}"]
  pol_prefix = "${var.app_name}-${var.env_name}-"
  pol_suffix = "-pol1"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmPolicyAssignment-Infra-nsg-on-subnet" {
  source                     = "../module/Enable-AzureRmPolicyAssignment"
  p_ass_name                 = "enforce-nsg-under-vnet-${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_names,0)}"
  p_ass_scope                = "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,0)}"
  p_ass_policy_definition_id = "${element(module.Create-AzureRmPolicyDefinition.policy_ids,0)}"
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = "${element(module.Create-AzureRmNetworkSecurityGroup-Infra.nsgs_ids,0)}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmPolicyAssignment-Infra-udr-on-subnet" {
  source                     = "../module/Enable-AzureRmPolicyAssignment"
  p_ass_name                 = "enforce-udr-under-vnet-${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_names,0)}"
  p_ass_scope                = "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,0)}"
  p_ass_policy_definition_id = "${element(module.Create-AzureRmPolicyDefinition.policy_ids,1)}"
  p_ass_key_parameter1       = "udrId"
  p_ass_value_parameter1     = "${element(module.Create-AzureRmRoute-Infra.rt_ids,0)}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmRoleDefinition-Apps" {
  source      = "../module/Create-AzureRmRoleDefinition"
  roles       = ["${var.roles}"]
  role_prefix = "${var.app_name}-${var.env_name}-"
  role_suffix = "-role1"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmRoleAssignment" {
  source                  = "../module/Enable-AzureRmRoleAssignment"
  ass_countRoleAssignment = "${length(var.roles)}"

  ass_scopes = ["${data.azurerm_resource_group.Apps.id}",
    "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,0)}",
    "${element(module.Create-AzureRmRoute-Infra.rt_ids,0)}",
    "${element(module.Create-AzureRmNetworkSecurityGroup-Infra.nsgs_ids,0)}",
    "${data.azurerm_resource_group.Infr.id}",
    "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_id}",
    "${data.azurerm_storage_account.Infr.id}",
  ]

  ass_role_definition_ids = "${module.Create-AzureRmRoleDefinition-Apps.role_ids}"
  ass_principal_id        = "${lookup(var.service_principals[1], "Application_object_id")}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

####################################################
##########              Apps              ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "MyApps" {
  name     = "${element(split("/",element(module.Enable-AzureRmRoleAssignment.role_assignment_scopes,0)),4)}"
  provider = "azurerm.service_principal_apps"
}

## Core Apps components
module "Create-AzureRmStorageAccount-Apps" {
  source                      = "../module/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_apps_name}"
  sa_resource_group_name      = "${data.azurerm_resource_group.MyApps.name}"
  sa_location                 = "${data.azurerm_resource_group.MyApps.location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${data.azurerm_resource_group.MyApps.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

## Core Network components
module "Create-AzureRmNetworkSecurityGroup-Apps" {
  source                  = "../module/Create-AzureRmNetworkSecurityGroup"
  nsgs                    = ["${var.apps_nsgs}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${data.azurerm_resource_group.MyApps.location}"
  nsg_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  nsg_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  nsgrules                = ["${var.apps_nsgrules}"]

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmApplicationkSecurityGroup-Apps" {
  source                  = "../module/Create-AzureRmApplicationSecurityGroup"
  asgs                    = ["${var.asgs}"]
  asg_prefix              = "${var.app_name}-${var.env_name}-"
  asg_suffix              = "-asg1"
  asg_location            = "${data.azurerm_resource_group.MyApps.location}"
  asg_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  asg_tags                = "${data.azurerm_resource_group.MyApps.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmSubnet-Apps" {
  source                     = "../module/Create-AzureRmSubnet"
  subnet_resource_group_name = "${element(split("/",element(module.Enable-AzureRmRoleAssignment.role_assignment_scopes,4)),4)}" #Call this variable like this to create an implicit depedency, the goal here is to wait for the role assignement to be effective
  subnet_prefix              = "${var.app_name}-${var.env_name}-"
  subnet_suffix              = "-snet1"
  snets                      = ["${var.apps_snets}"]
  vnets                      = "${module.Create-AzureRmVirtualNetwork-Infra.vnet_names}"
  nsgs_ids                   = "${module.Create-AzureRmNetworkSecurityGroup-Infra.nsgs_ids}"
  subnet_route_table_ids     = "${module.Create-AzureRmRoute-Infra.rt_ids}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

## Virtual Machines components
module "Create-AzureRmAvailabilitySet-Apps" {
  source                  = "../module/Create-AzureRmAvailabilitySet"
  ava_availabilitysets    = ["${var.Availabilitysets}"]
  ava_prefix              = "${var.app_name}-${var.env_name}-"
  ava_suffix              = "-avs1"
  ava_location            = "${data.azurerm_resource_group.MyApps.location}"
  ava_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  ava_tags                = "${data.azurerm_resource_group.MyApps.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "../module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${data.azurerm_resource_group.MyApps.location}"
  lb_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  LbRules                = ["${var.LbRules}"]

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmNetworkInterface-Apps" {
  source                  = "../module/Create-AzureRmNetworkInterface"
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

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmVm-Apps" {
  source                  = "../module/Create-AzureRmVm"
  sa_bootdiag_storage_uri = "${module.Create-AzureRmStorageAccount-Apps.sa_primary_blob_endpoint}"

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

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

/*
#Need improvment 1 : NEED MAJOR UPDATE to fit with AzureRM provider 1.21.0
module "Create-AzureRmVmss-Apps" {
  source                   = "../module/Create-AzureRmVmss"
  sa_bootdiag_storage_uri  = "${module.Create-AzureRmStorageAccount-Apps.sa_primary_blob_endpoint}"
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

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

#Need improvment 1 : NEED MAJOR UPDATE to use the native terraform resource
# Infra cross services for Apps
module "Enable-AzureRmRecoveryServicesBackupProtection-Apps" {
  source                      = "../module/Enable-AzureRmRecoveryServicesBackupProtection"
  resource_names              = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_names,module.Create-AzureRmVm-Apps.Windows_Vms_names)}"     #Names of the resources to backup
  resource_group_names        = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_rgnames,module.Create-AzureRmVm-Apps.Windows_Vms_rgnames)}" #Resource Group Names of the resources to backup
  resource_ids                = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_ids,module.Create-AzureRmVm-Apps.Windows_Vms_ids)}"         #Ids of the resources to backup
  bck_rsv_name                = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_name}"
  bck_rsv_resource_group_name = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_rgname}"
  bck_ProtectedItemType       = "Microsoft.ClassicCompute/virtualMachines"
  bck_BackupPolicyName        = "BackupPolicy-Schedule1"
  bck_location                = "${data.azurerm_resource_group.Infr.location}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}
*/

## Infra common services
module "Create-AzureRmAutomationAccount-Apps" {
  source                   = "../module/Create-AzureRmAutomationAccount"
  auto_name                = "${var.app_name}-${var.env_name}-auto1"
  auto_location            = "${data.azurerm_resource_group.MyApps.location}"
  auto_resource_group_name = "${data.azurerm_resource_group.MyApps.name}"
  auto_sku                 = "${var.auto_sku}"
  auto_tags                = "${data.azurerm_resource_group.MyApps.tags}"
  auto_credentials         = ["${var.service_principals}"]                    #If no need just set to []

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}
