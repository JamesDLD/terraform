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
variable "ass_role_definition_ids" {
  description = "Role assignement Ids"
  type        = "list"
  default     = ["xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
}
variable "ass_scopes" {
  type    = "list"
  default = ["subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/apps-test-prod1-prd-rg"]
}

#Action
module "Enable-AzureRmRoleAssignment" {
  source                  = "https://github.com/JamesDLD/terraform/tree/master/module/Enable-AzureRmRoleAssignment/"
  ass_countRoleAssignment = "${length(var.ass_role_definition_ids)}"
  ass_scopes              = "${length(var.ass_scopes)}"
  ass_role_definition_ids = "${var.ass_role_definition_ids}"
  ass_principal_id        = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```