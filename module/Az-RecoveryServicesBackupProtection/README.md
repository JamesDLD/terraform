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

variable "Windows_Vms" {
  default = [
    {
      BackupPolicyName              = "BackupPolicy-Schedule1" #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1)
    },
  ]
}

#Call module
module "Az-RecoveryServicesBackupProtection-Demo" {
  source                       = "github.com/JamesDLD/terraform/module/Az-RecoveryServicesBackupProtection"
  subscription_id              = var.subscription_id
  bck_vms_names                = ["jdld-sand1-rdg1","MyVmName2"]     #Names of the resources to backup
  bck_vms_resource_group_names = ["infr-jdld-noprd-rg1","RgOfVM2"]  #Resource Group Names of the resources to backup
  bck_vms                      = var.Windows_Vms
  bck_rsv_name                 = "infra-jdld-infr-rsv1"
  bck_rsv_resource_group_name  = "infr-jdld-noprd-rg1"
}
```