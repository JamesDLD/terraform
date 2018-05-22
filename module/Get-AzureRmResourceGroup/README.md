Usage
-----

```hcl
#Set the Provider
provider "azurerm" {
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "rg_apps_name" {
  default = "apps-jdld-sand1-rg1"
}

#Call module
module "Get-AzureRmResourceGroup-Apps" {
  source  = "./module/Get-AzureRmResourceGroup"
  rg_name = "${var.rg_apps_name}"
}

resource "azurerm_managed_disk" "test" {
  name                 = "managed_disk_name"
  location             = "${module.Get-AzureRmResourceGroup-Apps.rg_location}"
  resource_group_name  = "${module.Get-AzureRmResourceGroup-Apps.rg_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  tags                 = "${module.Get-AzureRmResourceGroup-Apps.rg_tags}"
}

```