# Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${lookup(var.service_principals[0], "Application_Id")}"
  client_secret   = "${lookup(var.service_principals[0], "Application_Secret")}"
  tenant_id       = "${var.tenant_id}"
  alias           = "service_principal_apps"
}

# Module
## Prerequisistes Inventory
module "Get-AzureRmResourceGroup-Infr" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${var.rg_infr_name}"

  providers {
    "azurerm" = "azurerm.service_principal_apps"
  }
}
