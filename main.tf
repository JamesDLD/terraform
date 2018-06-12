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
module "Get-AzureRmResourceGroup-Infr" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${var.rg_infr_name}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Get-AzureRmResourceGroup-Apps" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${var.rg_apps_name}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

## Core Infra components
module "Create-AzureRmRecoveryServicesVault-Infr" {
  source                  = "./module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "infra-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  rsv_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
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

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmStorageAccount-Infr" {
  source                      = "./module/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_infr_name}"
  sa_resource_group_name      = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  sa_location                 = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

## Core Network components
module "Create-AzureRmVirtualNetwork-Infra" {
  source                   = "./module/Create-AzureRmVirtualNetwork"
  vnets                    = ["${var.vnets}"]
  vnet_prefix              = "infra-${var.app_name}-${var.env_name}-"
  vnet_suffix              = "-net1"
  vnet_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  vnet_location            = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  vnet_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmNetworkSecurityGroup-Infra" {
  source                  = "./module/Create-AzureRmNetworkSecurityGroup"
  nsgs                    = ["${var.infra_nsgs}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  nsg_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  nsg_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"
  nsgrules                = ["${var.infra_nsgrules}"]

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmRoute-Infra" {
  source                 = "./module/Create-AzureRmRoute"
  rt_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
  rt_location            = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"
  routes                 = ["${var.routes}"]
  route_tables           = ["${var.route_tables}"]
  rt_prefix              = "${var.app_name}-${var.env_name}-"
  rt_suffix              = "-rt1"
  rt_tags                = "${module.Get-AzureRmResourceGroup-Infr.rg_tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

## Secops policies & RBAC roles
module "Create-AzureRmPolicyDefinition" {
  source     = "./module/Create-AzureRmPolicyDefinition"
  policies   = ["${var.policies}"]
  pol_prefix = "${var.app_name}-${var.env_name}-"
  pol_suffix = "-pol1"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmPolicyAssignment-Infra-nsg-on-subnet" {
  source                     = "./module/Enable-AzureRmPolicyAssignment"
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
  source                     = "./module/Enable-AzureRmPolicyAssignment"
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
  source      = "./module/Create-AzureRmRoleDefinition"
  roles       = ["${var.roles}"]
  role_prefix = "${var.env_name}-"
  role_suffix = "-role1"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmRoleAssignment" {
  source                  = "./module/Enable-AzureRmRoleAssignment"
  ass_countRoleAssignment = "${length(var.roles)}"

  ass_scopes = ["${module.Get-AzureRmResourceGroup-Apps.rg_id}",
    "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,0)}",
    "${element(module.Create-AzureRmRoute-Infra.rt_ids,0)}",
    "${element(module.Create-AzureRmNetworkSecurityGroup-Infra.nsgs_ids,0)}",
    "${module.Get-AzureRmResourceGroup-Infr.rg_id}",
    "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_id}",
    "${module.Create-AzureRmStorageAccount-Infr.sa_id}",
  ]

  ass_role_definition_ids = "${module.Create-AzureRmRoleDefinition-Apps.role_ids}"
  ass_principal_id        = "${lookup(var.service_principals[1], "Application_object_id")}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

#module.Get-AzureRmResourceGroup-Infr.rg_id

####################################################
##########              Apps              ##########
####################################################

## Prerequisistes Inventory
module "Get-AzureRmResourceGroup-MyApps" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${element(split("/",element(module.Enable-AzureRmRoleAssignment.role_assignment_scopes,0)),4)}" #"${var.rg_apps_name}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

## Core Apps components
module "Create-AzureRmStorageAccount-Apps" {
  source                      = "./module/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_apps_name}"
  sa_resource_group_name      = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  sa_location                 = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

## Core Network components
module "Create-AzureRmNetworkSecurityGroup-Apps" {
  source                  = "./module/Create-AzureRmNetworkSecurityGroup"
  nsgs                    = ["${var.apps_nsgs}"]
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  nsg_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  nsg_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
  nsgrules                = ["${var.apps_nsgrules}"]

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmApplicationkSecurityGroup-Apps" {
  source                  = "./module/Create-AzureRmApplicationSecurityGroup"
  asgs                    = ["${var.asgs}"]
  asg_prefix              = "${var.app_name}-${var.env_name}-"
  asg_suffix              = "-asg1"
  asg_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  asg_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  asg_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmSubnet-Apps" {
  source                     = "./module/Create-AzureRmSubnet"
  subnet_resource_group_name = "${module.Get-AzureRmResourceGroup-Infr.rg_name}"
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
  source                  = "./module/Create-AzureRmAvailabilitySet"
  ava_availabilitysets    = ["${var.Availabilitysets}"]
  ava_prefix              = "${var.app_name}-${var.env_name}-"
  ava_suffix              = "-avs1"
  ava_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  ava_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  ava_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "./module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  lb_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
  LbRules                = ["${var.LbRules}"]

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmNetworkInterface-Apps" {
  source                  = "./module/Create-AzureRmNetworkInterface"
  Linux_Vms               = ["${var.Linux_Vms}"]                                         #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                       #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "${var.app_name}-${var.env_name}-"
  nic_suffix              = "-nic1"
  nic_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  nic_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  subnets_ids             = "${module.Create-AzureRmSubnet-Apps.subnets_ids}"
  lb_backend_ids          = "${module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids}"
  nic_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
  nsgs_ids                = "${module.Create-AzureRmNetworkSecurityGroup-Apps.nsgs_ids}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

module "Create-AzureRmVm-Apps" {
  source                  = "./module/Create-AzureRmVm"
  sa_bootdiag_storage_uri = "${module.Create-AzureRmStorageAccount-Apps.sa_primary_blob_endpoint}"
  Linux_Vms               = ["${var.Linux_Vms}"]                                                   #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = ["${var.Windows_Vms}"]                                                 #If no need just fill "Windows_Vms = []" in the tfvars file
  vm_location             = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  vm_resource_group_name  = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  vm_prefix               = "${var.app_name}-${var.env_name}-"
  vm_tags                 = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
  app_admin               = "${var.app_admin}"
  pass                    = "${var.pass}"
  ssh_key                 = "${var.ssh_key}"
  ava_set_ids             = "${module.Create-AzureRmAvailabilitySet-Apps.ava_set_ids}"
  Linux_nics_ids          = "${module.Create-AzureRmNetworkInterface-Apps.Linux_nics_ids}"
  Windows_nics_ids        = "${module.Create-AzureRmNetworkInterface-Apps.Windows_nics_ids}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

/*
module "Create-AzureRmVmss-Apps" {
  source                   = "./module/Create-AzureRmVmss"
  sa_bootdiag_storage_uri  = "${module.Create-AzureRmStorageAccount-Apps.sa_primary_blob_endpoint}"
  Linux_Ss_Vms             = ["${var.Linux_Ss_Vms}"]                                                #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Ss_Vms           = ["${var.Windows_Ss_Vms}"]                                              #If no need just fill "Linux_Vms = []" in the tfvars file
  vmss_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  vmss_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  vmss_prefix              = "${var.app_name}-${var.env_name}-"
  vmss_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
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
*/

# Infra cross services for Apps
module "Enable-AzureRmRecoveryServicesBackupProtection-Apps" {
  source                      = "./module/Enable-AzureRmRecoveryServicesBackupProtection"
  resource_names              = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_names,module.Create-AzureRmVm-Apps.Windows_Vms_names)}"     #Names of the resources to backup
  resource_group_names        = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_rgnames,module.Create-AzureRmVm-Apps.Windows_Vms_rgnames)}" #Resource Group Names of the resources to backup
  resource_ids                = "${concat(module.Create-AzureRmVm-Apps.Linux_Vms_ids,module.Create-AzureRmVm-Apps.Windows_Vms_ids)}"         #Ids of the resources to backup
  bck_rsv_name                = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_name}"
  bck_rsv_resource_group_name = "${module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_rgname}"
  bck_ProtectedItemType       = "Microsoft.ClassicCompute/virtualMachines"
  bck_BackupPolicyName        = "BackupPolicy-Schedule1"
  bck_location                = "${module.Get-AzureRmResourceGroup-Infr.rg_location}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}

/* Commented for test purposes
module "Create-DnsThroughApi" {
  source               = "./module/Create-DnsThroughApi"
  dns_fqdn_api         = "${var.dns_fqdn_api}"
  dns_secret           = "${var.dns_secret}"
  dns_application_name = "${var.dns_application_name}"
  xpod_dns_zone_name   = "${var.xpod_dns_zone_name}"
  vpod_dns_zone_name   = "${var.vpod_dns_zone_name}"

  Dns_Wan_RecordsCount = "${var.Dns_Wan_RecordsCount}" #If no need just set to "0"
  Dns_Wan_Records      = ["${var.Dns_Wan_Records}"]    #If no need just set to []

  Dns_Host_RecordsCount = "${var.Dns_Vms_RecordsCount + var.Dns_Lbs_RecordsCount}"                                                                                                                                                                        #If no need just set to "0"
  Dns_Hostnames         = ["${concat(module.Create-AzureRmVm-Apps.Linux_Vms_names,module.Create-AzureRmVm-Apps.Windows_Vms_names,module.Create-AzureRmLoadBalancer-Apps.lb_names)}"]                                                                      #If no need just set to []
  Dns_Ips               = ["${concat(module.Create-AzureRmNetworkInterface-Apps.Linux_nics_private_ip_address,module.Create-AzureRmNetworkInterface-Apps.Windows_nics_private_ip_address,module.Create-AzureRmLoadBalancer-Apps.lb_private_ip_address)}"] #If no need just set to []
}


## Infra common services
module "Create-AzureRmAutomationAccount-Apps" {
  source                   = "./module/Create-AzureRmAutomationAccount"
  auto_name                = "${var.app_name}-${var.env_name}-auto1"
  auto_location            = "${module.Get-AzureRmResourceGroup-MyApps.rg_location}"
  auto_resource_group_name = "${module.Get-AzureRmResourceGroup-MyApps.rg_name}"
  auto_sku                 = "${var.auto_sku}"
  auto_tags                = "${module.Get-AzureRmResourceGroup-MyApps.rg_tags}"
  auto_credentials         = ["${var.service_principals}"]                         #If no need just set to []
}
*/

