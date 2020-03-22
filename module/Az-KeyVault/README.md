Usage
-----

```hcl
#Set the Provider
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  version         = "~> 2.0"
  features {}
}
provider "azuread" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
}

#Set authentication variables
variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "client_id" {
  description = "Azure service principal application Id."
}

variable "client_secret" {
  description = "Azure service principal application Secret."
}

#Set resource variables
variable "app_name" {
  default = "jdld"
}

variable "env_name" {
  default = "sand1"
}

variable "default_tags" {
  type = map(string)

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call resource / module
data "azuread_service_principal" "demo" {
  application_id = var.client_id
}

module "Az-KeyVault-demo" {
  source                 = "github.com/JamesDLD/terraform/module/Az-KeyVault"
  key_vaults             = [
    {
      suffix_name            = "sci"
      policy1_tenant_id      = var.tenant_id
      policy1_object_id      = data.azuread_service_principal.demo.object_id
      policy1_application_id = data.azuread_service_principal.demo.application_id
    },
  ]
  kv_tenant_id           = var.tenant_id
  kv_prefix              = "${var.app_name}-${var.env_name}-"
  kv_suffix              = "-kv1"
  kv_location            = "francecentral"
  kv_resource_group_name = "infr-jdld-noprd-rg1"
  kv_sku                 = "standard"
  kv_tags                = var.default_tags
}
```