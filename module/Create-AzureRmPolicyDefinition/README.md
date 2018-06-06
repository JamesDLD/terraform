Usage
-----
```
#Set the Provider
provider "azurerm" {
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable

variable "policies" {
  type = "list"

  default = [
    {
      policy_suffix_name = "enforce-nsg-on-subnet" #Used to name the policy and to call json template files located into the module's folder
      policy_type        = "Custom"
      mode               = "All"
    },
    {
      policy_suffix_name = "enforce-udr-on-subnet" #Used to name the policy and to call json template files located into the module's folder
      policy_type        = "Custom"
      mode               = "All"
    },
  ]
}

#Action
module "Create-AzureRmPolicyDefinition" {
  source     = "./module/Create-AzureRmPolicyDefinition"
  policies   = ["${var.policies}"]
  pol_prefix = "ApplicationToto-"
  pol_suffix = "-pol1"
}
```