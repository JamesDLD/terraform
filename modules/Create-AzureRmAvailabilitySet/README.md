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
variable "Availabilitysets" {
  type = "map"

  default = {
    suffix_name = "rdg"
  }
}

variable "app_name" {
  default = "jdld"
}

variable "env_name" {
  default = "sand1"
}

variable "location" {
  default = "northeurope"
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
module "Create-AzureRmAvailabilitySet-Apps" {
  source                  = "./modules/Create-AzureRmAvailabilitySet"
  ava_availabilitysets    = ["${var.Availabilitysets}"]
  ava_prefix              = "${var.app_name}-${var.env_name}-"
  ava_suffix              = "-avs1"
  ava_location            = "${var.location}"
  ava_resource_group_name = "${var.rg_apps_name}"
  ava_tags                = "${var.default_tags}"
}
```