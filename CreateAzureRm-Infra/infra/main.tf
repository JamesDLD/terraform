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

module "Az-KeyVault-Infr" {
  source                 = "../../module/Az-KeyVault"
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
module "Az-VirtualNetwork-Infra" {
  source                   = "../../module/Az-VirtualNetwork"
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

module "Az-Subnet-Infra" {
  source                     = "../../module/Az-Subnet"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = module.Az-VirtualNetwork-Infra.vnet_rgnames[0]
  snet_list                  = var.snets
  vnet_names                 = module.Az-VirtualNetwork-Infra.vnet_names
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

module "Az-RouteTable-Infra" {
  source                 = "../../module/Az-RouteTable"
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
module "Az-PolicyDefinition" {
  source     = "../../module/Az-PolicyDefinition"
  policies   = var.policies
  pol_prefix = "${var.app_name}-${var.env_name}-"
  pol_suffix = "-pol1"

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Az-RoleDefinition-Apps" {
  source      = "../../module/Az-RoleDefinition"
  roles       = var.roles
  role_prefix = "${var.app_name}-${var.env_name}-"
  role_suffix = "-role1"

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Az-RoleAssignment-Apps" {
  source                     = "../../Az-RoleAssignment"
  ass_countRoleAssignment = length(var.roles)
  ass_scopes   = [
    data.azurerm_resource_group.Apps.id,
    module.Az-VirtualNetwork-Infra.vnet_ids[0],
    module.Az-RouteTable-Infra.rt_ids[0],
    module.Az-NetworkSecurityGroup-Infra.nsgs_ids[0],
    data.azurerm_resource_group.Infr.id,
    module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_id,
    data.azurerm_storage_account.Infr.id,
  ]
  ass_role_definition_ids = odule.Az-RoleDefinition-Apps.role_ids
  ass_principal_id = var.service_principals[1]["Application_object_id"]

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Az-Firewall-Infr" {
  source                 = "../../module/Az-Firewall"
  fw_resource_group_name = data.azurerm_resource_group.Infr.name
  fw_location            = data.azurerm_resource_group.Infr.location
  fw_prefix              = "${var.app_name}-${var.env_name}-fw1"
  fw_subnet_id           = element(module.Az-Subnet-Infra.subnets_ids, 0)
  fw_tags                = data.azurerm_resource_group.Infr.tags

  providers = {
    azurerm = azurerm.service_principal_infra
  }
}

module "Az-PolicyAssignment-Infra-nsg-on-apps-subnet" {
  source                     = "../../module/Az-PolicyAssignment"
  p_ass_name                 = "enforce-nsg-under-vnet-${module.Az-VirtualNetwork-Infra.vnet_names[1]}"
  p_ass_scope                = module.Az-VirtualNetwork-Infra.vnet_ids[1]
  p_ass_policy_definition_id = module.Az-PolicyDefinition.policy_ids[0]
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = module.Az-NetworkSecurityGroup-Infra.nsgs_ids[0]

  providers {
    azurerm = azurerm.service_principal_infra
  }
}
module "Az-PolicyAssignment-Infra-udr-on-subnet" {
  source                     = "../../module/Az-PolicyAssignment"
  p_ass_name                 = "enforce-udr-under-vnet-${module.Az-VirtualNetwork-Infra.vnet_names[1]}"
  p_ass_scope                = module.Az-VirtualNetwork-Infra.vnet_ids[1]
  p_ass_policy_definition_id = module.Az-PolicyDefinition.policy_ids[1]
  p_ass_key_parameter1       = "udrId"
  p_ass_value_parameter1     = module.Az-RouteTable-Infra.rt_ids[0]

  providers {
    azurerm = azurerm.service_principal_infra
  }
}