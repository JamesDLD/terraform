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
variable "route_tables" {
  default = [
  {
    rt_suffix_name = "core"
  },
  ]
}
variable "routes" {
  default = [
  {
    name                   = "all_to_firewall"
    Id_rt                  = "0" #Id of the route table list
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "198.18.1.4"
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
module "Az-RouteTable-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-RouteTable"
  rt_resource_group_name = "infr-jdld-noprd-rg1"
  rt_location            = "francecentral"
  route_tables           = var.route_tables
  routes                 = var.routes
  rt_prefix              = "infra-demo-"
  rt_suffix              = "-rt1"
  rt_tags                = var.default_tags
}
```