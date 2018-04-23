resource "azurerm_template_deployment" "resources_to_backup" {
  count               = "${length(var.resource_names)}"
  name                = "${element(var.resource_names,count.index)}-bck-DEP"
  resource_group_name = "${var.bck_rsv_resource_group_name}"
  template_body       = "${file("./modules/Enable-AzureRmRecoveryServicesBackupProtection/AzureRmRecoveryServicesBackupProtection_template.json")}"
  deployment_mode     = "Incremental"

  parameters = {
    protectedItemType         = "${var.bck_ProtectedItemType}"
    resourcegroupname         = "${var.bck_rsv_resource_group_name}"
    vaultName                 = "${var.bck_rsv_name}"
    backuppolicyname          = "${var.bck_BackupPolicyName}"
    location                  = "${var.bck_location}"
    resourcename              = "${element(var.resource_names,count.index)}"
    resourceresourcegroupname = "${element(var.resource_group_names,count.index)}"
    resourceid                = "${element(var.resource_ids,count.index)}"
  }
}
