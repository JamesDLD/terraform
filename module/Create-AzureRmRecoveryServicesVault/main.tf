resource "azurerm_template_deployment" "backup_vault" {
  name                = "${var.rsv_name}-DEP"
  resource_group_name = "${var.rsv_resource_group_name}"
  template_body       = "${file("../module/Create-AzureRmRecoveryServicesVault/AzureRmRecoveryServicesVault_template.json")}"
  deployment_mode     = "Incremental"

  parameters {
    vaultName = "${var.rsv_name}"
    rsvtags   = "${jsonencode(var.rsv_tags)}"
  }

  #Terraform sends only string to azurerm template, I had to convert it to integer or array into the ARM Template Json, for info : https://github.com/terraform-providers/terraform-provider-azurerm/issues/34
}

resource "azurerm_template_deployment" "backup_policies" {
  count               = "${length(var.rsv_backup_policies)}"
  name                = "${azurerm_template_deployment.backup_vault.outputs["vaultName"]}-${lookup(var.rsv_backup_policies[count.index], "Name")}-DEP"
  resource_group_name = "${var.rsv_resource_group_name}"
  template_body       = "${file("../module/Create-AzureRmRecoveryServicesVault/AzureRmRecoveryServicesVaultPolicy_template.json")}"
  deployment_mode     = "Incremental"

  parameters = {
    vaultName                                    = "${azurerm_template_deployment.backup_vault.outputs["vaultName"]}"
    policyName                                   = "${lookup(var.rsv_backup_policies[count.index], "Name")}"
    StringToConvertscheduleRunTimes              = "${lookup(var.rsv_backup_policies[count.index], "scheduleRunTimes")}"
    timeZone                                     = "${lookup(var.rsv_backup_policies[count.index], "timeZone")}"
    StringToConvertdailyRetentionDurationCount   = "${lookup(var.rsv_backup_policies[count.index], "dailyRetentionDurationCount")}"
    StringToConvertweeklyRetentionDurationCount  = "${lookup(var.rsv_backup_policies[count.index], "weeklyRetentionDurationCount")}"
    StringToConvertmonthlyRetentionDurationCount = "${lookup(var.rsv_backup_policies[count.index], "monthlyRetentionDurationCount")}"
  }

  #Terraform sends only string to azurerm template, I had to convert it to integer or array into the ARM Template Json, for info : https://github.com/terraform-providers/terraform-provider-azurerm/issues/34
}
