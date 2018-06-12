Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "roles" {
  type = "list"

  default = [
    {
      suffix_name = "apps-write-subnet"
      actions     = "Microsoft.Network/virtualNetworks/subnets/Write Microsoft.Network/virtualNetworks/subnets/read Microsoft.Network/virtualNetworks/subnets/join/action"
      not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
    },
    {
      suffix_name = "apps-join-infra-nsg"
      actions     = "Microsoft.Network/networkSecurityGroups/join/action"
      not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
    },
    {
      suffix_name = "apps-armdeploy-infra"
      actions     = "Microsoft.Resources/deployments/*"
      not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
    },
    {
      suffix_name = "apps-enrollbackup-infra"
      actions     = "Microsoft.RecoveryServices/*"
      not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
    },
  ]
}

#Call module
module "Create-AzureRmRoleDefinition-Apps" {
  source      = "./module/Create-AzureRmRoleDefinition"
  roles       = ["${var.roles}"]
  role_prefix = "TeamRole-"
  role_suffix = "-role1"
}
```