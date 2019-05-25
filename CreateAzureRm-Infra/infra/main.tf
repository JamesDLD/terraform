# Providers (Infra & Apps)
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.service_principals[0]["Application_Id"]
  client_secret   = var.service_principals[0]["Application_Secret"]
  tenant_id       = var.tenant_id
  alias           = "service_principal_infra"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.service_principals[1]["Application_Id"]
  client_secret   = var.service_principals[1]["Application_Secret"]
  tenant_id       = var.tenant_id
  alias           = "service_principal_apps"
}

####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "Infr" {
  name     = var.rg_infr_name
  provider = azurerm.service_principal_infra
}

data "azurerm_resource_group" "Apps" {
  name     = var.rg_apps_name
  provider = azurerm.service_principal_infra
}

## Core Infra components
module "Create-AzureRmRecoveryServicesVault-Infr" {
  source                  = "../../module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "infra-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = data.azurerm_resource_group.Infr.name
  rsv_tags                = data.azurerm_resource_group.Infr.tags
  rsv_backup_policies     = var.backup_policies

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Create-AzureRmKeyVault-Infr" {
  source                 = "../../module/Create-AzureRmKeyVault"
  key_vaults             = var.key_vaults
  kv_tenant_id           = var.tenant_id
  kv_prefix              = "${var.app_name}-${var.env_name}-"
  kv_suffix              = "-kv1"
  kv_location            = data.azurerm_resource_group.Infr.location
  kv_resource_group_name = data.azurerm_resource_group.Infr.name
  kv_sku                 = var.kv_sku
  kv_tags                = data.azurerm_resource_group.Infr.tags

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

data "azurerm_storage_account" "Infr" {
  name                = var.sa_infr_name
  resource_group_name = data.azurerm_resource_group.Infr.name
  provider            = azurerm.service_principal_infra
}

## Core Network components
module "Create-AzureRmVirtualNetwork-Infra" {
  source                   = "../../module/Create-AzureRmVirtualNetwork"
  vnets                    = var.vnets
  vnet_prefix              = "infra-${var.app_name}-${var.env_name}-"
  vnet_suffix              = "-net1"
  vnet_resource_group_name = data.azurerm_resource_group.Infr.name
  vnet_location            = data.azurerm_resource_group.Infr.location
  vnet_tags                = data.azurerm_resource_group.Infr.tags

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Create-AzureRmSubnet-Infra" {
  source                     = "../../module/Az-Subnet"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = module.Create-AzureRmVirtualNetwork-Infra[0].vnet_rgnames[0]
  snet_list                  = var.snets
  vnet_names                 = module.Create-AzureRmVirtualNetwork-Infra.vnet_names
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Az-NetworkSecurityGroup-Infra" {
  source                  = "../../module/Az-NetworkSecurityGroup"
  nsgs                    = var.infra_nsgs
  nsg_prefix              = "${var.app_name}-${var.env_name}-"
  nsg_suffix              = "-nsg1"
  nsg_location            = data.azurerm_resource_group.Infr.location
  nsg_resource_group_name = data.azurerm_resource_group.Infr.name
  nsg_tags                = data.azurerm_resource_group.Infr.tags
  nsgrules                = var.infra_nsgrules

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Create-AzureRmRoute-Infra" {
  source                 = "../../module/Create-AzureRmRoute"
  rt_resource_group_name = data.azurerm_resource_group.Infr.name
  rt_location            = data.azurerm_resource_group.Infr.location
  routes                 = var.routes
  route_tables           = var.route_tables
  rt_prefix              = "${var.app_name}-${var.env_name}-"
  rt_suffix              = "-rt1"
  rt_tags                = data.azurerm_resource_group.Infr.tags

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

## Secops policies & RBAC roles
module "Create-AzureRmPolicyDefinition" {
  source     = "../../module/Create-AzureRmPolicyDefinition"
  policies   = var.policies
  pol_prefix = "${var.app_name}-${var.env_name}-"
  pol_suffix = "-pol1"

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Create-AzureRmRoleDefinition-Apps" {
  source      = "../../module/Create-AzureRmRoleDefinition"
  roles       = var.roles
  role_prefix = "${var.app_name}-${var.env_name}-"
  role_suffix = "-role1"

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}
/*
module "Enable-AzureRmRoleAssignment" {
  source                  = "../../module/Enable-AzureRmRoleAssignment"
  ass_countRoleAssignment = length(var.roles)

  ass_scopes = [
    data.azurerm_resource_group.Apps.id,
    module.Create-AzureRmVirtualNetwork-Infra[0].vnet_ids[0],
    module.Create-AzureRmRoute-Infra[0].rt_ids[0],
    module.Az-NetworkSecurityGroup-Infra[0].nsgs_ids[0],
    data.azurerm_resource_group.Infr.id,
    module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_id,
    data.azurerm_storage_account.Infr.id,
  ]

  ass_role_definition_ids = module.Create-AzureRmRoleDefinition-Apps.role_ids
  ass_principal_id        = var.service_principals[1]["Application_object_id"]

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}
*/
/*
module "Create-AzureRmFirewall-Infr" {
  source                 = "../../module/Create-AzureRmFirewall"
  fw_resource_group_name = data.azurerm_resource_group.Infr.name
  fw_location            = data.azurerm_resource_group.Infr.location
  fw_prefix              = "${var.app_name}-${var.env_name}-fw1"
  fw_subnet_id           = element(module.Create-AzureRmSubnet-Infra.subnets_ids, 0)
  fw_tags                = data.azurerm_resource_group.Infr.tags

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}
Error with Terraform 0.12.0 -->
Error: Error building AzureRM Client: Error populating Client ID from the Azure CLI: No Authorization Tokens were found - please re-authenticate using `az login`.

  on variables.tf line 10, in provider "azurerm":
  10: provider "azurerm" {



Error: Error Creating/Updating Subnet "AzureFirewallSubnet" (Virtual Network "infra-jdld-infr-sec-net1" / Resource Group ""): network.SubnetsClient#CreateOrUpdate: Failure sending request: StatusCode=400 -- Original Error: Code="InvalidApiVersionParameter" Message="The api-version '2018-12-01' is invalid. The supported versions are '2019-05-01,2019-03-01,2018-11-01,2018-09-01,2018-08-01,2018-07-01,2018-06-01,2018-05-01,2018-02-01,2018-01-01,2017-12-01,2017-08-01,2017-06-01,2017-05-10,2017-05-01,2017-03-01,2016-09-01,2016-07-01,2016-06-01,2016-02-01,2015-11-01,2015-01-01,2014-04-01-preview,2014-04-01,2014-01-01,2013-03-01,2014-02-26,2014-04'."
*/
/*
Currently generating a bug on Apps
module "Enable-AzureRmPolicyAssignment-Infra-nsg-on-apps-subnet" {
  source                     = "../../module/Enable-AzureRmPolicyAssignment"
  p_ass_name                 = "enforce-nsg-under-vnet-${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_names,1)}"
  p_ass_scope                = "${element(module.Create-AzureRmVirtualNetwork-Infra.vnet_ids,1)}"
  p_ass_policy_definition_id = "${element(module.Create-AzureRmPolicyDefinition.policy_ids,0)}"
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = "${element(module.Az-NetworkSecurityGroup-Infra.nsgs_ids,0)}"

  providers {
    "azurerm" = "azurerm.service_principal_infra"
  }
}

module "Enable-AzureRmPolicyAssignment-Infra-udr-on-subnet" {
  source                     = "../../module/Enable-AzureRmPolicyAssignment"
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