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

#Call module & resources
module "Az-RoleDefinition-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-RoleDefinition"
  roles   = var.roles
  role_prefix = "jdld-demo-"
  role_suffix = "-role1"
}

data "azuread_service_principal" "demo" {
  application_id = var.client_id
}

module "Az-RoleAssignment-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-RoleAssignment"
  ass_countRoleAssignment = 2
  ass_scopes   = ["/subscriptions/${var.subscription_id}/resourceGroups/infr-jdld-noprd-rg1",
                   "/subscriptions/${var.subscription_id}/resourceGroups/infr-jdld-noprd-rg1"]
  ass_role_definition_ids = module.Az-RoleDefinition-Demo.role_ids
  ass_principal_id = data.azuread_service_principal.demo.object_id
}
```