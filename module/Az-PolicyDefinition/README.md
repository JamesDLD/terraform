Usage
-----
```
#Set the Provider
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  version         = "~> 2.0"
  features {}
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

#Call module
module "Az-PolicyDefinition-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-PolicyDefinition"
  policies   = var.policies
  pol_prefix = "ApplicationToto-"
  pol_suffix = "-pol1"
}
```