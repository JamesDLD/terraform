Prerequisite
-----

You have accepted the terms for the urn `paloaltonetworks:vmseries1:bundle1:8.1.0` on the target Azure subscription.
The following cmdlet have been used to do it.

```hcl
az vm image list --all --publisher paloaltonetworks --offer vmseries --sku bundle1
az vm image accept-terms --urn paloaltonetworks:vmseries1:bundle1:8.1.0
```

Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  version         = "~> 2.0"
  features {}
}

#Set authentication variabless
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
variable "pac" {
  description = "Palo Alto list with it's properties."
  default = [
    {
      suffix_name                   = "pac"
      suffix_pip_domainNameLabel    = "mydomainlabel"
      id                            = "1"
      vmAvailabilityZone            = "1"
      vmSize                        = "Standard_D3_v2"
      vmImageVersion                = "latest"
      vmImagePublisher              = "paloaltonetworks"
      vmImageOffer                  = "vmseries1"
      vmImageSku                    = "bundle1"
      vm_managed_disk_type          = "StandardSSD_LRS"
      enable_accelerated_networking = "true"
      subnet_mgmt_name              = "pac-mgmt"
      subnet_untrust_name           = "pac-untrust"
      subnet_trust_name             = "pac-trust"
      subnet_mgmt_ip                = "100.69.32.116"
      subnet_untrust_ip             = "100.69.32.100"
      subnet_trust_ip               = "100.69.32.244"
    },
  ]
}

variable "pac_tags" {
  description = "Palo Alto tags."
  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Create-AzureRmPaloAltoAz-Demo" {
  source                                  = "../../Create-AzureRmPaloAltoAz"
  pac                                     = var.pac_tags
  pac_resource_group_name                 = "infr-jdld-noprd-rg1"
  pac_tags                                = var.pac_tags
  pac_virtual_network_name                = "bp1-vnet1"
  pac_virtual_network_resource_group_name = "infr-jdld-noprd-rg1"
  adminUsername                           = "myadminlogin"
  adminPassword                           = "myadminPass123StoredInASecretFile"
  pac_nsg_name                            = "infr-jdld-noprd-rg1"
  boot_diag_storage_account_name          = "mystorageaccount"
}
```