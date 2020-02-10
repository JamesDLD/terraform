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

module "Create-AzureRmRecoveryServicesVault-Infr" {
  source                  = "git::https://github.com/JamesDLD/terraform.git//module/Create-AzureRmRecoveryServicesVault?ref=master"
  rsv_name                = "${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = data.azurerm_resource_group.Infr.name
  rsv_tags                = data.azurerm_resource_group.Infr.tags
  rsv_backup_policies     = var.backup_policies
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
  source                      = "JamesDLD/Az-VirtualNetwork/azurerm"
  version                     = "0.1.4"
  net_prefix                  = "${var.app_name}-${var.env_name}"
  network_resource_group_name = data.azurerm_resource_group.Infr.name
  virtual_networks            = var.vnets
  subnets                     = var.snets
  route_tables                = var.route_tables
  network_security_groups     = var.infra_nsgs
  pips                        = {}
  vnets_to_peer               = var.vnets_to_peer
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
  role_suffix = "-rdef1"
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
    module.Create-AzureRmRecoveryServicesVault-Infr.backup_vault_id,
    data.azurerm_storage_account.Infr.id,
  ]
  ass_role_definition_ids = module.Az-RoleDefinition-Apps.role_ids
  ass_principal_id        = var.service_principals[1]["Application_object_id"]
}
# -
# - Azure Firewall
# -

resource "azurerm_public_ip" "fw_pip" {
  name                = "${var.app_name}-${var.env_name}-fw1-pip1"
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_firewall" "fw" {
  name                = "${var.app_name}-${var.env_name}-fw1"
  location            = azurerm_public_ip.fw_pip.location
  resource_group_name = azurerm_public_ip.fw_pip.resource_group_name
  tags                = data.azurerm_resource_group.Infr.tags

  ip_configuration {
    name                 = "${var.app_name}-${var.env_name}-fw1-CFG"
    subnet_id            = element(module.Az-VirtualNetwork-Infra.subnet_ids, 0)
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

resource "azurerm_firewall_application_rule_collection" "rules" {
  for_each            = var.az_firewall_rules["application_rule_collections"]
  name                = each.key
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = data.azurerm_resource_group.Infr.name
  priority            = lookup(each.value, "priority", null)
  action              = lookup(each.value, "action", null)

  dynamic "rule" {
    for_each = lookup(each.value, "rules", null)

    content {
      name             = lookup(rule.value, "name", null)
      description      = lookup(rule.value, "description", null)
      source_addresses = lookup(rule.value, "source_addresses", null)
      fqdn_tags        = lookup(rule.value, "fqdn_tags", null)
      target_fqdns     = lookup(rule.value, "target_fqdns", null)
      dynamic "protocol" {
        for_each = lookup(rule.value, "protocols", null)

        content {
          port = lookup(protocol.value, "port", null)
          type = lookup(protocol.value, "type", null)
        }
      }
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "rules" {
  for_each            = var.az_firewall_rules["network_rule_collections"]
  name                = each.key
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = data.azurerm_resource_group.Infr.name
  priority            = lookup(each.value, "priority", null)
  action              = lookup(each.value, "action", null)

  dynamic "rule" {
    for_each = lookup(each.value, "rules", null)

    content {
      name                  = lookup(rule.value, "name", null)
      description           = lookup(rule.value, "description", null)
      source_addresses      = lookup(rule.value, "source_addresses", null)
      destination_ports     = lookup(rule.value, "destination_ports", null)
      destination_addresses = lookup(rule.value, "destination_addresses", null)
      protocols             = lookup(rule.value, "protocols", null)
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "rules" {
  for_each            = var.az_firewall_rules["nat_rule_collections"]
  name                = each.key
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = data.azurerm_resource_group.Infr.name
  priority            = lookup(each.value, "priority", null)
  action              = lookup(each.value, "action", null)

  dynamic "rule" {
    for_each = lookup(each.value, "rules", null)

    content {
      name                  = lookup(rule.value, "name", null)
      description           = lookup(rule.value, "description", null)
      destination_addresses = lookup(rule.value, "destination_addresses", [azurerm_public_ip.fw_pip.ip_address])
      destination_ports     = lookup(rule.value, "destination_ports", null)
      protocols             = lookup(rule.value, "protocols", null)
      source_addresses      = lookup(rule.value, "source_addresses", null)
      translated_address    = lookup(rule.value, "translated_address", null)
      translated_port       = lookup(rule.value, "translated_port", null)
    }
  }
}

resource "azurerm_log_analytics_workspace" "infra" {
  name                = "${var.app_name}-${var.env_name}-logm1" #The log analytics workspace name must be unique
  sku                 = "PerGB2018"                             #Refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_monitor_diagnostic_setting" "fw" {
  name                       = azurerm_firewall.fw.name
  target_resource_id         = azurerm_firewall.fw.id
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

# -
# - Policy
# -

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
