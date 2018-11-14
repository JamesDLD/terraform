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
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "pac" {
  type        = "map"
  description = "Palo Alto list with it's properties"

  default =   {
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
  }
}

variable "pac_tags" {
  type = "map"
  description = "Palo Alto tags."

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Create-AzureRmPaloAltoAz-MyApp" {
  source                                  = "../module/Create-AzureRmPaloAltoAz"
  pac                                     = ["${var.pac}"]
  pac_resource_group_name                 = "myrg"
  pac_tags                                = "${var.pac_tags}"
  pac_virtual_network_name                = "my_virtual_network_name"
  pac_virtual_network_resource_group_name = "my_virtual_network_resource_group_name"
  adminUsername                           = "myadminlogin"
  adminPassword                           = "myadminlogin123"
  pac_nsg_name                            = "my_pip_mgmt_nsg_name"
  boot_diag_storage_account_name          = "mystorageaccount"
}
```