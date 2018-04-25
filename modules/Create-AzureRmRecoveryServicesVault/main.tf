resource "azurerm_template_deployment" "backup_vault" {
  name                = "${var.rsv_name}-DEP"
  resource_group_name = "${var.rsv_resource_group_name}"
  template_body       = "${file("./modules/Create-AzureRmRecoveryServicesVault/AzureRmKeyVault_template.json")}"
  deployment_mode     = "Incremental"

  parameters {
    vaultName = "${var.rsv_name}"
  }
}

resource "azurerm_template_deployment" "backup_policies" {
  count               = "${length(var.rsv_backup_policies)}"
  name                = "${azurerm_template_deployment.backup_vault.outputs["vaultName"]}-${lookup(var.rsv_backup_policies[count.index], "Name")}-DEP"
  resource_group_name = "${var.rsv_resource_group_name}"
  template_body       = "${file("./modules/Create-AzureRmRecoveryServicesVault/AzureRmKeyVaultPolicy_template.json")}"
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

  #Terraform sends only string, I had to convert it to integer or array into the Json, for info : https://github.com/terraform-providers/terraform-provider-azurerm/issues/34
  #Also for the same reason we can't tag our subresources
}
