
Prerequisite
-----
You should register to the preview to be able to create an Azure Bastion. Using PowerShell :
```
Login-AzAccount
Register-AzProviderFeature -FeatureName AllowBastionHost -ProviderNamespace Microsoft.Network
Register-AzResourceProvider -ProviderNamespace Microsoft.Network
```

Wait for few minutes then use the following cmdlet to ensure that you are registred :
```
Get-AzProviderFeature -ListAvailable
```

Usage
-----
```
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

variable "default_tags" {
  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Az-Bastion-Demo" {
  source              = "github.com/JamesDLD/terraform/module/Az-Bastion"
  location            = "westeurope"
  resourceGroupName   = "infr-jdld-noprd-rg2"
  bastionHostName     = "apps-bas1"
  existingVNETName    = "infra-jdld-infr-apps-net1"
  publicIpAddressName = "apps-bas1-pip1"
  subnetAddressPrefix = "192.168.1.224/27"
  tags                = var.default_tags
}

#Module's output
output "bastion_id" {
  value = module.Az-Bastion-Demo.bastion_id
}
```