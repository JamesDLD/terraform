Usage
-----

```hcl
#Set the Provider
provider "azurerm" {
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "dns_fqdn_api" {
  default = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "dns_secret" {
  default = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "dns_application_name" {
  default = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "xpod_dns_zone_name" {
  default = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "vpod_dns_zone_name" {
  default = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "Dns_Wan_RecordsCount" {
  default = "1"
}

variable "Dns_Wan_Records" {
  type = "map"

  default = {
    hostname  = "portal-web-iis"
    static_ip = "169.69.32.132"
  }
}

variable "app_name" {
  default = "jdld"
}

variable "env_name" {
  default = "sand1"
}

variable "Dns_Vms_RecordsCount" {
  default = "1"
}

variable "Vms" {
  type = "map"

  default = {
    suffix_name       = "rdg"                    #If Availabilitysets it must equals the Availabilitysets suffix_name / If Load Balancer it must with the Lbs suffix_name
    id                = "1"                      #Id of the VM
    Id_BackupVault    = "0"                      #Id of the Backup Recovery Vault
    Id_Lb             = "1"                      #Id of the Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "0"                      #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "10.0.3.4"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "MicrosoftWindowsServer"
    offer             = "WindowsServer"
    sku               = "2016-Datacenter"
    lun               = "0"
    disk_size_gb      = "32"
  }
}

variable "Dns_Lbs_RecordsCount" {
  default = "1"
}

variable "Lbs" {
  type = "map"

  default = {
    suffix_name = "bou"       #It must equals the Vm suffix_name
    Id_Subnet   = "0"         #Id of the Subnet
    static_ip   = "10.0.3.13"
  }
}

#Call module
module "Create-DnsThroughApi" {
  source               = "./modules/Create-DnsThroughApi"
  dns_fqdn_api         = "${var.dns_fqdn_api}"
  dns_secret           = "${var.dns_secret}"
  dns_application_name = "${var.dns_application_name}"
  xpod_dns_zone_name   = "${var.xpod_dns_zone_name}"
  vpod_dns_zone_name   = "${var.vpod_dns_zone_name}"

  Dns_Wan_RecordsCount = "${var.Dns_Wan_RecordsCount}" #If no need just set to "0"
  Dns_Wan_Records      = ["${var.Dns_Wan_Records}"]    #If no need just set to []

  vm_prefix            = "${var.app_name}-${var.env_name}-"
  Dns_Vms_RecordsCount = "${var.Dns_Vms_RecordsCount}"                #If no need just set to "0"
  Vms                  = ["${concat(var.Linux_Vms,var.Windows_Vms)}"] #If no need just set to []

  lb_prefix            = "${var.app_name}-${var.env_name}-"
  Dns_Lbs_RecordsCount = "${var.Dns_Lbs_RecordsCount}"      #If no need just set to "0"
  Lbs                  = ["${var.Lbs}"]                     #If no need just set to []
}
```