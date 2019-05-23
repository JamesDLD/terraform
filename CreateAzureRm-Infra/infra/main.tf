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
  source                  = "github.com/JamesDLD/terraform/module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "infra-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  rsv_tags                = "${data.azurerm_resource_group.Infr.tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmKeyVault-Infr" {
  source                 = "github.com/JamesDLD/terraform/module/Create-AzureRmKeyVault"
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
  source                   = "github.com/JamesDLD/terraform/module/Create-AzureRmVirtualNetwork"
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

module "Create-AzureRmSubnet-Infra" {
  source                     = "github.com/JamesDLD/terraform/module/Az-Subnet"
  subscription_id            = "${var.subscription_id}"
  subnet_resource_group_name = "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_rgnames,0)}"
  snet_list                  = ["${var.snets}"]
  vnet_names                 = "${module.Create-AzureRmVirtualNetwork-Infra.vnet_names}"
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Create-AzureRmNetworkSecurityGroup-Infra" {
  source                  = "github.com/JamesDLD/terraform/module/Create-AzureRmNetworkSecurityGroup"
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
  source                 = "github.com/JamesDLD/terraform/module/Create-AzureRmRoute"
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
  source     = "github.com/JamesDLD/terraform/module/Create-AzureRmPolicyDefinition"
  policies   = ["${var.policies}"]
  pol_prefix = "${var.app_name}-${var.env_name}-"
  pol_suffix = "-pol1"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

/*
Currently generating a bug on Apps
module "Enable-AzureRmPolicyAssignment-Infra-nsg-on-apps-subnet" {
  source                     = "github.com/JamesDLD/terraform/module/Enable-AzureRmPolicyAssignment"
  p_ass_name                 = "enforce-nsg-under-vnet-${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_names,1)}"
  p_ass_scope                = "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,1)}"
  p_ass_policy_definition_id = "${element(module.Create-AzureRmPolicyDefinition.policy_ids,0)}"
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = "${element(module.Create-AzureRmNetworkSecurityGroup-Infra.nsgs_ids,0)}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmPolicyAssignment-Infra-udr-on-subnet" {
  source                     = "github.com/JamesDLD/terraform/module/Enable-AzureRmPolicyAssignment"
  p_ass_name                 = "enforce-udr-under-vnet-${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_names,1)}"
  p_ass_scope                = "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,1)}"
  p_ass_policy_definition_id = "${element(module.Create-AzureRmPolicyDefinition.policy_ids,1)}"
  p_ass_key_parameter1       = "udrId"
  p_ass_value_parameter1     = "${element(module.Create-AzureRmRoute-Infra.rt_ids,0)}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}
*/
module "Create-AzureRmRoleDefinition-Apps" {
  source      = "github.com/JamesDLD/terraform/module/Create-AzureRmRoleDefinition"
  roles       = ["${var.roles}"]
  role_prefix = "${var.app_name}-${var.env_name}-"
  role_suffix = "-role1"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmRoleAssignment" {
  source                  = "github.com/JamesDLD/terraform/module/Enable-AzureRmRoleAssignment"
  ass_countRoleAssignment = "${length(var.roles)}"

  ass_scopes = ["${data.azurerm_resource_group.Apps.id}",
    "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,1)}",
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

module "Create-AzureRmFirewall-Infr" {
  source                 = "github.com/JamesDLD/terraform/module/Create-AzureRmFirewall"
  fw_resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  fw_location            = "${data.azurerm_resource_group.Infr.location}"
  fw_prefix              = "${var.app_name}-${var.env_name}-fw1"
  fw_subnet_id           = "${element(module.Create-AzureRmSubnet-Infra.subnets_ids,0)}"
  fw_tags                = "${data.azurerm_resource_group.Infr.tags}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}
