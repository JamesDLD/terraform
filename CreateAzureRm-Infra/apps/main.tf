# Providers (Infra & Apps)

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.service_principals[1]["Application_Id"]
  client_secret   = var.service_principals[1]["Application_Secret"]
  tenant_id       = var.tenant_id
  version         = ">= 1.31.0" #Use the last version tested through an Azure DevOps pipeline here : https://dev.azure.com/jamesdld23/vpc_lab/_build?definitionId=6&_a=summary
}

# Call Resources and Modules

####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "Infr" {
  name = var.rg_infr_name
}

data "azurerm_storage_account" "Infr" {
  name                = var.sa_infr_name
  resource_group_name = var.rg_infr_name
}

data "azurerm_recovery_services_vault" "vault" {
  name                = var.bck_rsv_name
  resource_group_name = data.azurerm_resource_group.Infr.name
}

data "azurerm_subnet" "snets" {
  count                = length(var.apps_snets)
  name                 = var.apps_snets[count.index]["subnet_name"]
  virtual_network_name = var.apps_snets[count.index]["vnet_name"]
  resource_group_name  = data.azurerm_resource_group.Infr.name
}

####################################################
##########              Apps              ##########
####################################################

## Prerequisistes Inventory
data "azurerm_resource_group" "MyApps" {
  name = var.rg_apps_name
}

##Log monitor
resource "azurerm_log_analytics_workspace" "Apps" {
  name                = var.log_monitor_name
  location            = data.azurerm_resource_group.MyApps.location
  resource_group_name = data.azurerm_resource_group.MyApps.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

## Core Network components

resource "azurerm_network_security_group" "apps_nsgs" {
  for_each            = var.apps_nsgs
  name                = "${var.app_name}-${var.env_name}-nsg${each.value["id"]}"
  location            = data.azurerm_resource_group.MyApps.location
  resource_group_name = data.azurerm_resource_group.MyApps.name

  dynamic "security_rule" {
    for_each = each.value["security_rules"]
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
  tags = data.azurerm_resource_group.MyApps.tags
}


## Virtual Machines components

module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "JamesDLD/Az-LoadBalancer/azurerm"
  version                = "0.1.1"
  Lbs                    = var.Lbs
  LbRules                = var.LbRules
  lb_prefix              = "${var.app_name}-${var.env_name}"
  lb_location            = data.azurerm_resource_group.MyApps.location
  lb_resource_group_name = data.azurerm_resource_group.MyApps.name
  Lb_sku                 = var.Lb_sku
  subnets_ids            = data.azurerm_subnet.snets.*.id
  lb_additional_tags     = { iac = "Terraform" }
}

module "Az-Vm" {
  source                            = "JamesDLD/Az-Vm/azurerm"
  version                           = "0.1.1"
  sa_bootdiag_storage_uri           = data.azurerm_storage_account.Infr.primary_blob_endpoint #(Mandatory)
  subnets_ids                       = data.azurerm_subnet.snets.*.id                          #(Mandatory)
  linux_vms                         = var.linux_vms                                           #(Mandatory)
  windows_vms                       = var.windows_vms                                         #(Mandatory)
  vm_resource_group_name            = data.azurerm_resource_group.MyApps.name
  vm_prefix                         = "" #(Optional)
  admin_username                    = var.app_admin
  admin_password                    = var.pass
  ssh_key                           = var.ssh_key
  workspace_name                    = azurerm_log_analytics_workspace.Apps.name                  #(Optional)
  enable_log_analytics_dependencies = false                                                      #(Optional) Default is false
  recovery_services_vault_name      = data.azurerm_recovery_services_vault.vault.name            #(Optional)
  recovery_services_vault_rgname    = data.azurerm_resource_group.Infr.name                      #(Optional) Use the RG's location if not set
  nsgs_ids                          = [for x in azurerm_network_security_group.apps_nsgs : x.id] #(Optional)
  internal_lb_backend_ids           = module.Create-AzureRmLoadBalancer-Apps.lb_backend_ids      #(Optional)
  vm_additional_tags                = { iac = "Terraform" }

  #All other optional values
  /*
  key_vault_name                    = var.key_vault_name                                         #(Optional)
  key_vault_rgname                  = data.azurerm_resource_group.Infr.name                      #(Optional) Use the RG's location if not set
  vm_location                       = element(module.Az-VirtualNetwork-Demo.vnet_locations, 0) #(Optional) Use the RG's location if not set
  workspace_resource_rgname = ""                              #(Optional) Use the RG's location if not set
  public_ip_ids                     = module.Az-VirtualNetwork-Demo.public_ip_ids              #(Optional)
  public_lb_backend_ids             = ["public_backend_id1", "public_backend_id1"]             #(Optional)
*/

}
# Infra cross services for Apps
#N/A

## Infra common services
#N/A

