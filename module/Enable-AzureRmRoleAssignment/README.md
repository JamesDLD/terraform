Usage
-----

```hcl
#Set the Provider
provider "azurerm" {
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  version = "1.8"
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
data "azurerm_subscription" "primary" {}

data "azurerm_role_definition" "customs" {
  count              = "${length(var.ass_role_definition_ids)}"
  role_definition_id = "${element(var.ass_role_definition_ids,count.index)}"
  scope              = "${data.azurerm_subscription.primary.id}"
}

module "Enable-AzureRmRoleAssignment" {
  source                  = "github.com/JamesDLD/terraform/module/Enable-AzureRmRoleAssignment"
  version 				        = "9c23185"
  ass_countRoleAssignment = "${length(data.azurerm_role_definition.customs.*.id)}"
  ass_scopes              = "${var.ass_scopes}"
  ass_role_definition_ids = "${data.azurerm_role_definition.customs.*.id}"
  ass_principal_id        = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```