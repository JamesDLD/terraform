Usage
-----

```hcl
#Set the Provider
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
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
      policy_type = "Custom"
      mode        = "All"
    },
    {
      suffix_name = "enforce-udr-on-subnet" #Used to name the policy and to call json template files located into the module's folder
      policy_type = "Custom"
      mode        = "All"
    },
  ]
}

variable "apps_nsgs" {
  default = [
    {
      id = "1"
      security_rules = [
        {
          description                = "Demo1"
          direction                  = "Inbound"
          name                       = "ALL_to_NIC_tcp-3389"
          access                     = "Allow"
          priority                   = "2000"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          destination_port_range     = "3389"
          protocol                   = "tcp"
          source_port_range          = "*"
        },
      ]
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
  source     = "../../Az-PolicyDefinition"
  policies   = var.policies
  pol_prefix = "ApplicationToto-"
  pol_suffix = "-pol1"
}

resource "azurerm_virtual_network" "demo" {
  name                = "infra-demo-net1"
  location            = "francecentral"
  resource_group_name = "infr-jdld-noprd-rg1"
  address_space       = ["198.18.6.0/24", "198.18.7.0/24"]
  tags                = var.default_tags
}

resource "azurerm_network_security_group" "demo" {
  count               = length(var.apps_nsgs)
  name                = "jdld-demo-nsg${var.apps_nsgs[count.index]["id"]}"
  location            = "francecentral"
  resource_group_name = "infr-jdld-noprd-rg1"

  dynamic "security_rule" {
    for_each = var.apps_nsgs[count.index]["security_rules"]
    content {
      description                  = lookup(security_rule.value, "description", null)
      direction                    = lookup(security_rule.value, "direction", null)
      name                         = lookup(security_rule.value, "name", null)
      access                       = lookup(security_rule.value, "access", null)
      priority                     = lookup(security_rule.value, "priority", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      protocol                     = lookup(security_rule.value, "protocol", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
    }
  }
  tags = var.default_tags
}

module "Az-PolicyAssignment-Infra-nsg-on-subnet" {
  source                     = "github.com/JamesDLD/terraform/module/Az-PolicyAssignment"
  p_ass_name                 = "enforce-nsg-on-subnet-for-infra-vnet"
  p_ass_scope                = element(azurerm_virtual_network.demo.*.id, 0)
  p_ass_policy_definition_id = module.Az-PolicyDefinition-Demo.policy_ids[0]
  p_ass_key_parameter1       = "nsgId"
  p_ass_value_parameter1     = element(azurerm_network_security_group.demo.*.id, 0)
}
```