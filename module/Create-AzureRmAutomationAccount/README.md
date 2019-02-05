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
variable "auto_sku" {
  default = "Basic"
}

variable "location" {
  default = "francecentral"
}

variable "rg_apps_name" {
  default = "apps-jdld-sand1-rg1"
}

variable "default_tags" {
  type = "map"

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Create-AzureRmAutomationAccount-Apps" {
  source                   = "./module/Create-AzureRmAutomationAccount"
  auto_name                = "${var.app_name}-${var.env_name}-auto1"
  auto_location            = "${var.location}"
  auto_resource_group_name = "${var.rg_apps_name}"
  auto_sku                 = "${var.auto_sku}"
  auto_tags                = "${var.default_tags}"
}


```