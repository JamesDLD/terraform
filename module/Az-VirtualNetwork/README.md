Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
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
variable "vnets" {
  default = [
  {
    vnet_suffix_name = "sec"
    address_spaces   = "198.18.1.0/24 198.18.2.0/24" #For multiple values add spaces between values
    dns_servers      = ""              #For multiple values add spaces between values
  },
  {
    vnet_suffix_name = "apps"
    address_spaces   = "198.18.4.0/24" #For multiple values add spaces between values
    dns_servers      = "198.18.4.4"              #For multiple values add spaces between values
  },
  ]
}

variable "default_tags" {
  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Az-VirtualNetwork-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-VirtualNetwork"
  vnets                    = var.vnets
  vnet_prefix              = "infra-demo-"
  vnet_suffix              = "-net1"
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
  vnet_location            = "francecentral"
  vnet_tags                = var.default_tags
}
```