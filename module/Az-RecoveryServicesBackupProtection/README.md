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
variable "Linux_Vms" {
  type = "map"

  default = {
    suffix_name       = "Name"
    id                = "1"                      #Id of the VM
    Id_Lb             = "777"                    #Id of the Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Nsg            = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "198.18.1.228"
    vm_size           = "Standard_DS1_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "redhat"
    offer             = "RHEL"
    sku               = "7.3"
    lun               = "0"
    disk_size_gb      = "32"
  }
}

#Call module
module "Enable-AzureRmRecoveryServicesBackupProtection-Apps" {
  source                       = "../module/Az-RecoveryServicesBackupProtection"
  subscription_id              = "xxxxxxxSubIdxxxxxxxx"
  bck_vms_names                = ["MyVmName1"]     #Names of the resources to backup
  bck_vms_resource_group_names = ["MyVmName1RgName"]  #Resource Group Names of the resources to backup
  bck_vms                      = ["${var.Linux_Vms}"]
  bck_rsv_name                 = "MyRsvName"
  bck_rsv_resource_group_name  = "MyRsvRgName"
}
```