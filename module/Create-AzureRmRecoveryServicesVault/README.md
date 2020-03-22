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
variable "backup_policies" {
  default = [
    {
      Name                 = "BackupPolicy-Schedule1"
      scheduleRunFrequency = "Daily"
      scheduleRunDays      = "null"
      scheduleRunTimes     = "2017-01-26T20:00:00Z"
      timeZone             = "Romance Standard Time"

      dailyRetentionDurationCount   = "14"
      weeklyRetentionDurationCount  = "2"
      monthlyRetentionDurationCount = "2"
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
module "Create-AzureRmRecoveryServicesVault-Demo" {
  source                     = "github.com/JamesDLD/terraform/module/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "infra-jdld-infr-rsv1"
  rsv_resource_group_name = "infr-jdld-noprd-rg1"
  rsv_tags                = var.default_tags
  rsv_backup_policies     = var.backup_policies
}
```