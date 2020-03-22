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
variable "roles" {
  default = [
    {
      suffix_name = "apps-contributor"
      actions     = "*"
      not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
    },
    {
      suffix_name = "apps-write-subnet"
      actions     = "Microsoft.Network/virtualNetworks/subnets/Write Microsoft.Network/virtualNetworks/subnets/read Microsoft.Network/virtualNetworks/subnets/delete Microsoft.Network/virtualNetworks/subnets/join/action"
      not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
    },
  ]
}

#Call module
module "Az-RoleDefinition-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-RoleDefinition"
  roles   = var.roles
  role_prefix = "jdld-demo-"
  role_suffix = "-role1"
}
```