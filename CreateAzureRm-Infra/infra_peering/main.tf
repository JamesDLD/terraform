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

provider "azuread" {
  subscription_id = var.subscription_id
  client_id       = var.service_principals[0]["Application_Id"]
  client_secret   = var.service_principals[0]["Application_Secret"]
  tenant_id       = var.tenant_id
}
####################################################
##########           Infra                ##########
####################################################

## Prerequisistes Inventory

data "azurerm_virtual_network" "sec" {
  name                = element(var.vnet_names, 0)
  resource_group_name = var.rg_infr_name
  provider            = azurerm.service_principal_infra
}

data "azurerm_virtual_network" "apps" {
  name                = element(var.vnet_names, 1)
  resource_group_name = var.rg_infr_name
  provider            = azurerm.service_principal_infra
}

## Core Network components
module "Enable-AzureRmVirtualNetworkPeering-vnet-sec-insub1" {
  source               = "../../module/Enable-AzureRmVirtualNetworkPeering"
  vnet_src_name        = data.azurerm_virtual_network.sec.name
  vnet_rg_src_name     = data.azurerm_virtual_network.sec.resource_group_name
  vnet_src_id          = data.azurerm_virtual_network.sec.id
  Disable_Vnet_Peering = "no"

  list_one = [
    {
      name                = data.azurerm_virtual_network.apps.name
      resource_group_name = data.azurerm_virtual_network.apps.resource_group_name
    },
  ]

  list_two   = []
  list_three = []
  list_four  = []
  list_five  = []
  list_six   = []
  list_seven = []
  list_eight = []

  providers = {
    azurerm.src            = azurerm.service_principal_infra
    azurerm.provider_one   = azurerm.service_principal_infra
    azurerm.provider_two   = azurerm.service_principal_infra
    azurerm.provider_three = azurerm.service_principal_infra
    azurerm.provider_four  = azurerm.service_principal_apps
    azurerm.provider_five  = azurerm.service_principal_apps
    azurerm.provider_six   = azurerm.service_principal_apps
    azurerm.provider_seven = azurerm.service_principal_apps
    azurerm.provider_eight = azurerm.service_principal_apps
  }
}

