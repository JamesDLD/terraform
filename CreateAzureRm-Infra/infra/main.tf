# Providers (Infra & Apps)
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.service_principals[0]["Application_Id"]
  client_secret   = var.service_principals[0]["Application_Secret"]
  tenant_id       = var.tenant_id
  version         = ">= 1.31.0" #Use the last version tested through an Azure DevOps pipeline here : https://dev.azure.com/jamesdld23/vpc_lab/_build?definitionId=6&_a=summary
}

####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
}

data "azurerm_resource_group" "Apps" {
  name = var.rg_apps_name
}

## Core Infra components

resource "azurerm_recovery_services_vault" "Infr" {
  for_each            = var.recovery_services_vault
  name                = "${each.value["prefix"]}-${var.app_name}-${var.env_name}-rsv${each.value["id"]}"
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  sku                 = lookup(each.value, "sku", "RS0")
  tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_recovery_services_protection_policy_vm" "Infr" {
  for_each            = var.recovery_services_protection_policy_vm
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.Infr.name
  timezone            = lookup(each.value, "timezone", "UTC")

  dynamic "backup" {
    for_each = lookup(each.value, "backup", null)
    content {
      frequency = lookup(backup.value, "frequency", null)
      time      = lookup(backup.value, "time", null)
    }
  }

  dynamic "retention_daily" {
    for_each = lookup(each.value, "retention_daily", null)
    content {
      count = lookup(retention_daily.value, "count", null)
    }
  }

  dynamic "retention_weekly" {
    for_each = lookup(each.value, "retention_weekly", null)
    content {
      count    = lookup(retention_weekly.value, "count", null)
      weekdays = lookup(retention_weekly.value, "weekdays", null)
    }
  }

  dynamic "retention_monthly" {
    for_each = lookup(each.value, "retention_monthly", null)
    content {
      count    = lookup(retention_monthly.value, "count", null)
      weekdays = lookup(retention_monthly.value, "weekdays", null)
      weeks    = lookup(retention_monthly.value, "weeks", null)
    }
  }

  dynamic "retention_yearly" {
    for_each = lookup(each.value, "retention_yearly", null)
    content {
      count    = lookup(retention_yearly.value, "count", null)
      weekdays = lookup(retention_yearly.value, "weekdays", null)
      weeks    = lookup(retention_yearly.value, "weeks", null)
      months   = lookup(retention_yearly.value, "months", null)
    }
  }

  /*
  This forces a destroy when adding a new vnet --> 
  virtual_network_name      = lookup(azurerm_recovery_services_vault.Infr, each.value["rsv_key"], null)["name"]

  Workaround is to perform an explicit depedency-->
  */
  depends_on          = [azurerm_recovery_services_vault.Infr]
  recovery_vault_name = "${lookup(var.recovery_services_vault, each.value["rsv_key"], "wrong_rsv_key_in_rsvpol")["prefix"]}-${var.app_name}-${var.env_name}-rsv${lookup(var.recovery_services_vault, each.value["rsv_key"], "wrong_rsv_key_in_rsvpol")["id"]}"
}

module "Az-KeyVault-Infr" {
  source                 = "git::https://github.com/JamesDLD/terraform.git//module/Az-KeyVault?ref=master"
  key_vaults             = var.key_vaults
  kv_tenant_id           = var.tenant_id
  kv_prefix              = "${var.app_name}-${var.env_name}-"
  kv_suffix              = "-kv1"
  kv_location            = data.azurerm_resource_group.Infr.location
  kv_resource_group_name = data.azurerm_resource_group.Infr.name
  kv_sku                 = var.kv_sku
  kv_tags                = data.azurerm_resource_group.Infr.tags
}

data "azurerm_storage_account" "Infr" {
  name                = var.sa_infr_name
  resource_group_name = data.azurerm_resource_group.Infr.name
}

## Core Network components
module "Az-VirtualNetwork-Infra" {
  source                      = "git::https://github.com/JamesDLD/terraform.git//module/Az-VirtualNetwork?ref=master"
  net_prefix                  = "infra-${var.app_name}-${var.env_name}"
  network_resource_group_name = data.azurerm_resource_group.Infr.name
  net_location                = data.azurerm_resource_group.Infr.location
  virtual_networks            = var.vnets
  subnets                     = var.snets
  route_tables                = var.route_tables
  network_security_groups     = var.infra_nsgs
  net_tags                    = data.azurerm_resource_group.Infr.tags
}

## Secops policies & RBAC roles
module "Az-PolicyDefinition" {
  source     = "git::https://github.com/JamesDLD/terraform.git//module/Az-PolicyDefinition?ref=master"
  policies   = var.policies
  pol_prefix = "${var.app_name}-${var.env_name}-"
  pol_suffix = "-pol1"
}

module "Az-RoleDefinition-Apps" {
  source      = "git::https://github.com/JamesDLD/terraform.git//module/Az-RoleDefinition?ref=master"
  roles       = var.roles
  role_prefix = "${var.app_name}-${var.env_name}-"
  role_suffix = "-role1"
}

module "Az-RoleAssignment-Apps" {
  source                  = "git::https://github.com/JamesDLD/terraform.git//module/Az-RoleAssignment?ref=master"
  ass_countRoleAssignment = length(var.roles)
  ass_scopes = [
    data.azurerm_resource_group.Apps.id,
    module.Az-VirtualNetwork-Infra.vnet_ids[0],
    module.Az-VirtualNetwork-Infra.route_table_ids[0],
    module.Az-VirtualNetwork-Infra.network_security_group_ids[0],
    data.azurerm_resource_group.Infr.id,
    azurerm_recovery_services_vault.Infr["rsv1"].id,
    data.azurerm_storage_account.Infr.id,
  ]
  ass_role_definition_ids = module.Az-RoleDefinition-Apps.role_ids
  ass_principal_id        = var.service_principals[1]["Application_object_id"]
}

/*
module "Az-Firewall-Infr" {
  source                 = "git::https://github.com/JamesDLD/terraform.git//module/Az-Firewall?ref=master"
  fw_resource_group_name = data.azurerm_resource_group.Infr.name
  fw_location            = data.azurerm_resource_group.Infr.location
  fw_prefix              = "${var.app_name}-${var.env_name}-fw1"
  fw_subnet_id           = element(module.Az-VirtualNetwork-Infra.subnet_ids, 0)
  fw_tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_log_analytics_workspace" "infra" {
  name                = "${var.app_name}-${var.env_name}-lm1" #The log analytics workspace name must be unique
  sku                 = "PerGB2018"                           #Refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_monitor_diagnostic_setting" "fw" {
  name                       = module.Az-Firewall-Infr.fw_name
  target_resource_id         = module.Az-Firewall-Infr.fw_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.infra.id

  log {
    category = "AzureFirewallApplicationRule"

    retention_policy {
      enabled = true
    }
  }

  log {
    category = "AzureFirewallNetworkRule"

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}
*/
/*
Currently not using those policies because the terraform resources with the suffix "association" generate an error when using terraform destroy cmdlet
module "Az-PolicyAssignment-Infra-nsg-on-apps-subnet" {
  source                     = "git::https://github.com/JamesDLD/terraform.git//module/Az-PolicyAssignment?ref=master"
  p_ass_name                 = "enforce-nsg-under-vnet-${module.Az-VirtualNetwork-Infra.vnet_names[1]}"
  p_ass_scope                = module.Az-VirtualNetwork-Infra.vnet_ids[1]
  p_ass_policy_definition_id = module.Az-PolicyDefinition.policy_ids[0]
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = module.Az-VirtualNetwork-Infra.network_security_group_ids[0]
}
module "Az-PolicyAssignment-Infra-udr-on-subnet" {
  source                     = "git::https://github.com/JamesDLD/terraform.git//module/Az-PolicyAssignment?ref=master"
  p_ass_name                 = "enforce-udr-under-vnet-${module.Az-VirtualNetwork-Infra.vnet_names[1]}"
  p_ass_scope                = module.Az-VirtualNetwork-Infra.vnet_ids[1]
  p_ass_policy_definition_id = module.Az-PolicyDefinition.policy_ids[1]
  p_ass_key_parameter1       = "udrId"
  p_ass_value_parameter1     = module.Az-VirtualNetwork-Infra.route_table_ids[0]
}
*/
