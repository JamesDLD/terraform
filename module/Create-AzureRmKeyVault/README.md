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
variable "key_vaults" {
  type = "map"

  default = {
    suffix_name       = "sci"
    policy1_tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    policy1_object_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    policy1_application_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }
}

variable "tenant_id" {
  default = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
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

variable "rg_infr_name" {
  default = "infr-jdld-noprd-rg1"
}

variable "kv_sku" {
  default = "standard"
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
module "Create-AzureRmKeyVault-Infr" {
  source                 = "./module/Create-AzureRmKeyVault"
  key_vaults             = ["${var.key_vaults}"]
  kv_tenant_id           = "${var.tenant_id}"
  kv_prefix              = "${var.app_name}-${var.env_name}-"
  kv_suffix              = "-kv1"
  kv_location            = "${var.location}"
  kv_resource_group_name = "${var.rg_infr_name}"
  kv_sku                 = "${var.kv_sku}"
  kv_tags                = "${var.default_tags}"
}
```