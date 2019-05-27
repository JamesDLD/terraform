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
variable "snets" {
  default = [
    {
    name              = "demo1"
    cidr_block        = "10.0.128.0/28"
    nsg_id            = "777"                                                                                                                                               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "777"                                                                                                                                               #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = "0"                                                                                                                                                 #Id of the vnet
    service_endpoints = "Microsoft.AzureActiveDirectory Microsoft.KeyVault Microsoft.Sql" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
    },
    {
    name              = "demo2"
    cidr_block        = "10.0.128.16/28"
    nsg_id            = "777"                                                                                                                                               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "777"                                                                                                                                               #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = "0"                                                                                                                                                 #Id of the vnet
    service_endpoints = "" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
    },
  ]
}

#Call module
module "Az-Subnet-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-Subnet"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = "infr-jdld-noprd-rg1"
  snet_list                  = var.snets
  vnet_names                 = ["bp1-vnet1","AnotherVnetName"]
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]
}
```