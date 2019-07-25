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
  name     = var.rg_infr_name
  provider = azurerm.service_principal_apps
}

data "azurerm_storage_account" "Infr" {
  name                = var.sa_infr_name
  resource_group_name = var.rg_infr_name
  provider            = azurerm.service_principal_apps
}

data "azurerm_recovery_services_vault" "vault" {
  name                = var.bck_rsv_name
  resource_group_name = data.azurerm_resource_group.Infr.name
  provider            = azurerm.service_principal_apps
}

data "azurerm_subnet" "snets" {
  count                = length(var.apps_snets)
  name                 = var.apps_snets[count.index]["subnet_name"]
  virtual_network_name = var.apps_snets[count.index]["vnet_name"]
  resource_group_name  = data.azurerm_resource_group.Infr.name
  provider             = azurerm.service_principal_apps
}

####################################################
##########              Apps              ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "MyApps" {
  name     = var.rg_apps_name
  provider = azurerm.service_principal_apps
}

data "azurerm_route_table" "Infr" {
  name                = "infra-jdld-infr-francecentral-rt1"
  resource_group_name = data.azurerm_resource_group.Infr.name
  provider            = azurerm.service_principal_apps
}

data "azurerm_network_security_group" "Infr" {
  name                = element(azurerm_network_security_group.apps_nsgs.*.name, 0)
  resource_group_name = var.rg_infr_name
  provider            = azurerm.service_principal_apps
}

## Core Network components
resource "azurerm_network_security_group" "apps_nsgs" {
  count               = length(var.apps_nsgs)
  name                = "${var.app_name}-${var.env_name}-nsg${var.apps_nsgs[count.index]["id"]}"
  location            = data.azurerm_resource_group.MyApps.location
  resource_group_name = data.azurerm_resource_group.MyApps.name

  dynamic "security_rule" {
    for_each = var.apps_nsgs[count.index]["security_rules"]
    content {
      description                  = lookup(security_rule.value, "description", null)
      direction                    = lookup(security_rule.value, "direction", null)
      name                         = lookup(security_rule.value, "name", null)
      access                       = lookup(security_rule.value, "access", null)
      priority                     = lookup(security_rule.value, "priority", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      protocol                     = lookup(security_rule.value, "protocol", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
    }
  }
  tags     = data.azurerm_resource_group.MyApps.tags
  provider = azurerm.service_principal_apps
}


## Virtual Machines components

module "Az-LoadBalancer-Apps" {
  source                 = "git::https://github.com/JamesDLD/terraform.git//module/Az-LoadBalancer?ref=feature/nomoreusingnull_resource"
  Lbs                    = var.Lbs
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = data.azurerm_resource_group.MyApps.location
  lb_resource_group_name = data.azurerm_resource_group.MyApps.name
  Lb_sku                 = var.Lb_sku
  subnets_ids            = data.azurerm_subnet.snets.*.id
  lb_tags                = data.azurerm_resource_group.MyApps.tags
  LbRules                = var.LbRules
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

module "Az-Vm-Apps" {
  source                             = "git::https://github.com/JamesDLD/terraform.git//module/Az-Vm?ref=feature/nomoreusingnull_resource"
  sa_bootdiag_storage_uri            = data.azurerm_storage_account.Infr.primary_blob_endpoint
  nsgs_ids                           = azurerm_network_security_group.apps_nsgs.*.id
  public_ip_ids                      = ["null"]
  internal_lb_backend_ids            = module.Az-LoadBalancer-Apps.lb_backend_ids
  public_lb_backend_ids              = ["null"]
  key_vault_id                       = ""
  rsv_id                             = data.azurerm_recovery_services_vault.vault.id
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""
  subnets_ids                        = data.azurerm_subnet.snets.*.id
  vms                                = var.vms
  linux_storage_image_reference      = var.linux_storage_image_reference
  windows_storage_image_reference    = var.windows_storage_image_reference #If no need just fill "windows_storage_image_reference = []" in the tfvars file
  vm_location                        = data.azurerm_resource_group.MyApps.location
  vm_resource_group_name             = data.azurerm_resource_group.MyApps.name
  vm_prefix                          = "${var.app_name}-${var.env_name}-"
  admin_username                     = var.app_admin
  admin_password                     = var.pass
  ssh_key                            = var.ssh_key
  vm_tags                            = data.azurerm_resource_group.MyApps.tags
  providers = {
    azurerm = azurerm.service_principal_apps
  }
}

# Infra cross services for Apps
#N/A

## Infra common services
#N/A
