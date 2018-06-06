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
variable "policy_definition_id" {
  default = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/providers/Microsoft.Authorization/policyDefinitions/jdld-sand1-enforce-nsg-on-subnet-pol1"
}

variable "vnet_id" {
  default = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/apps-jdld-sand1-rg1/providers/Microsoft.Network/virtualNetworks/myVirutalNetwork"
}

variable "nsgs_id" {
  default = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/apps-jdld-sand1-rg1/providers/Microsoft.Network/networkSecurityGroups/jdld-sand1-nic-all-nsg1"
}

#Action
module "Enable-AzureRmPolicyAssignment-Infra-nsg-on-subnet" {
  source                     = "./module/Enable-AzureRmPolicyAssignment"
  p_ass_name                 = "enforce-nsg-on-subnet-for-infra-vnet"
  p_ass_scope                = "${var.vnet_id}"
  p_ass_policy_definition_id = "${var.policy_definition_id}"
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = "${var.nsgs_id}"
}
```