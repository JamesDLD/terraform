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
# -
# - Network object
# -
variable "virtual_networks" {
  default = [
    {
      id            = "1"
      prefix        = "sec"
      address_space = ["198.18.1.0/24", "198.18.2.0/24"]
      bastion       = false
    },
    {
      id            = "1"
      prefix        = "apps"
      address_space = ["198.18.4.0/24"]
      bastion       = false
      dns_servers   = ["8.8.8.8"]
    },
  ]
}

variable "subnets" {
  default = [
    {
      virtual_network_iteration = "0"                                    #(Mandatory) 
      name                      = "test1"                                #(Mandatory) 
      address_prefix            = "198.18.1.0/26"                        #(Mandatory) 
      route_table_iteration     = "0"                                    #(Optional) delete this line for no NSG
      service_endpoints         = ["Microsoft.Sql", "Microsoft.Storage"] #(Optional) delete this line for no NSG
    },
    {
      virtual_network_iteration = "1"                  #(Mandatory) 
      name                      = "AzureBastionSubnet" #(Mandatory) 
      address_prefix            = "198.18.4.0/27"      #(Mandatory) 
    },
    {
      virtual_network_iteration = "1"              #(Mandatory) 
      name                      = "test2"          #(Mandatory) 
      address_prefix            = "198.18.4.32/27" #(Mandatory) 
      security_group_iteration  = "0"              #(Optional) delete this line for no NSG
      route_table_iteration     = "1"              #(Optional) delete this line for no NSG
    },
  ]
}
# -
# - Route Table
# -
variable "route_tables" {
  default = [
    {
      id     = "1"
      routes = []
    },
    {
      id = "2"
      routes = [
        {
          name           = "route1"
          address_prefix = "10.1.0.0/16"
          next_hop_type  = "vnetlocal"
        },
      ]
    },
  ]
}
# -
# - Network Security Group
# -
variable "network_security_groups" {
  default = [
    {
      id = "1"
      security_rules = [
        {
          name                       = "test1"
          description                = "My Test 1"
          priority                   = 101
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                         = "test2"
          description                  = "My Test 2"
          priority                     = 102
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "*"
          source_address_prefix        = "*"
          destination_address_prefixes = ["192.168.1.5", "192.168.1.6"]
        },
        {
          name                         = "test3"
          description                  = "My Test 3"
          priority                     = 103
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_ranges      = ["22", "3389"]
          source_address_prefix        = "*"
          destination_address_prefixes = ["192.168.1.5", "192.168.1.6"]
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
module "Az-VirtualNetwork-Demo" {
  source                      = "github.com/JamesDLD/terraform/module/Az-VirtualNetwork"
  net_prefix                  = "demo"
  network_resource_group_name = "infr-jdld-noprd-rg1"
  virtual_networks            = var.virtual_networks
  subnets                     = var.subnets
  route_tables                = var.route_tables
  network_security_groups     = var.network_security_groups
  net_tags                    = var.default_tags
}
```