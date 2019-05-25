resource "azurerm_template_deployment" "backup_vault" {
  name                = "${var.rsv_name}-DEP"
  resource_group_name = var.rsv_resource_group_name
  template_body       = file("${path.module}/AzureRmRecoveryServicesVault_template.json")
  deployment_mode     = "Incremental"

  parameters = {
    vaultName = var.rsv_name
    rsvtags   = jsonencode(var.rsv_tags)
  }
  #Terraform sends only string to azurerm template, I had to convert it to integer or array into the ARM Template Json, for info : https://github.com/terraform-providers/terraform-provider-azurerm/issues/34
}

resource "azurerm_template_deployment" "backup_policies" {
  count               = length(var.rsv_backup_policies)
  name                = "${azurerm_template_deployment.backup_vault.outputs["vaultName"]}-${var.rsv_backup_policies[count.index]["Name"]}-DEP"
  resource_group_name = var.rsv_resource_group_name
  template_body = file(
    "${path.module}/AzureRmRecoveryServicesVaultPolicy_template.json",
  )
  deployment_mode = "Incremental"

  parameters = {
    vaultName                                    = azurerm_template_deployment.backup_vault.outputs["vaultName"]
    policyName                                   = var.rsv_backup_policies[count.index]["Name"]
    StringToConvertscheduleRunTimes              = var.rsv_backup_policies[count.index]["scheduleRunTimes"]
    timeZone                                     = var.rsv_backup_policies[count.index]["timeZone"]
    StringToConvertdailyRetentionDurationCount   = var.rsv_backup_policies[count.index]["dailyRetentionDurationCount"]
    StringToConvertweeklyRetentionDurationCount  = var.rsv_backup_policies[count.index]["weeklyRetentionDurationCount"]
    StringToConvertmonthlyRetentionDurationCount = var.rsv_backup_policies[count.index]["monthlyRetentionDurationCount"]
  }
  #Terraform sends only string to azurerm template, I had to convert it to integer or array into the ARM Template Json, for info : https://github.com/terraform-providers/terraform-provider-azurerm/issues/34
}

