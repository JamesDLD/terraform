Usage
-----
```hcl
#provider "azurerm" {
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
variable "apps_nsgs" {
  default = [
    {
      suffix_name = "nic-all"
    },
  ]
}

variable "apps_nsgrules" {
  default = [
  {
    Id_Nsg                     = "0"                   #Id of the apps Network Security Group
    direction                  = "Inbound"
    suffix_name                = "ALL_to_NIC_tcp-3389"
    access                     = "Allow"
    priority                   = "2000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3389"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    Id_Nsg                     = "0"
    direction                  = "Inbound"
    suffix_name                = "ALL_to_NIC_tcp-22"
    access                     = "Allow"
    priority                   = "2001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    Id_Nsg                     = "0"
    direction                  = "Inbound"
    suffix_name                = "ALL_to_NIC_Deny-All"
    access                     = "Deny"
    priority                   = "4096"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    protocol                   = "*"
    source_port_range          = "*"
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

#Call resource
module "Az-NetworkSecurityGroup-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Az-NetworkSecurityGroup"
  nsgs                    = var.apps_nsgs
  nsgrules                = var.apps_nsgrules
  nsg_prefix              = "jdld-demo-"
  nsg_suffix              = "-nsg1"
  nsg_location            = "francecentral"
  nsg_resource_group_name = "infr-jdld-noprd-rg1"
  nsg_tags                = var.default_tags
}
```