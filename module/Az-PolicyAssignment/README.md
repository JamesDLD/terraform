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
variable "policies" {
  default = [
    {
      suffix_name = "enforce-nsg-on-subnet" #Used to name the policy and to call json template files located into the module's folder
      policy_type        = "Custom"
      mode               = "All"
    },
    {
      suffix_name = "enforce-udr-on-subnet" #Used to name the policy and to call json template files located into the module's folder
      policy_type        = "Custom"
      mode               = "All"
    },
  ]
}

variable "apps_nsgs" {
  default = [
    {
      suffix_name = "nic-all"
    },
  ]
}

variable "vnets" {
  default = [
  {
    vnet_suffix_name = "infra"
    address_spaces   = "198.18.6.0/24 198.18.7.0/24" #For multiple values add spaces between values
    dns_servers      = ""              #For multiple values add spaces between values
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
module "Az-PolicyDefinition-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-PolicyDefinition"
  policies   = var.policies
  pol_prefix = "ApplicationToto-"
  pol_suffix = "-pol1"
}

module "Az-VirtualNetwork-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-VirtualNetwork"
  vnets                    = var.vnets
  vnet_prefix              = "infra-demo-"
  vnet_suffix              = "-net1"
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
  vnet_location            = "francecentral"
  vnet_tags                = var.default_tags
}

module "Az-NetworkSecurityGroup-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-NetworkSecurityGroup"
  nsgs                    = var.apps_nsgs
  nsgrules                = []
  nsg_prefix              = "jdld-demo-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "francecentral"
  nsg_resource_group_name = "infr-jdld-noprd-rg1"
  nsg_tags                = var.default_tags
}

module "Az-PolicyAssignment-Infra-nsg-on-subnet" {
  source                     = "github.com/JamesDLD/terraform/module/Az-PolicyAssignment"
  p_ass_name                 = "enforce-nsg-on-subnet-for-infra-vnet"
  p_ass_scope                = module.Az-VirtualNetwork-Demo.vnet_ids[0]
  p_ass_policy_definition_id = module.Az-PolicyDefinition-Demo.policy_ids[0]
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = module.Az-NetworkSecurityGroup-Demo.nsgs_ids[0]
}
```