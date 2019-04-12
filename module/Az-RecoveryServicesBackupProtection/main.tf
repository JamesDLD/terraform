resource "null_resource" "target_ids" {
  count = "${length(var.bck_vms)}"

  triggers = {
    source_vm_id = "${"${lookup(var.bck_vms[count.index], "BackupPolicyName")}" == "777" ? 
                                "" : "/subscriptions/${var.subscription_id}/resourceGroups/${element(var.bck_vms_resource_group_names,count.index)}/providers/Microsoft.Compute/virtualMachines/${element(var.bck_vms_names,count.index)}"}"

    backup_policy_id = "${"${lookup(var.bck_vms[count.index], "BackupPolicyName")}" == "777" ? 
                                "" : "/subscriptions/${var.subscription_id}/resourceGroups/${var.bck_rsv_resource_group_name}/providers/Microsoft.RecoveryServices/vaults/${var.bck_rsv_name}/backupPolicies/${lookup(var.bck_vms[count.index], "BackupPolicyName")}"}"
  }
}

locals {
  source_vm_ids     = "${compact(null_resource.target_ids.*.triggers.source_vm_id)}"
  backup_policy_ids = "${compact(null_resource.target_ids.*.triggers.backup_policy_id)}"
}

resource "azurerm_recovery_services_protected_vm" "vm_resources_to_backup" {
  count               = "${length(local.source_vm_ids)}"
  resource_group_name = "${var.bck_rsv_resource_group_name}"
  recovery_vault_name = "${var.bck_rsv_name}"
  source_vm_id        = "${element(local.source_vm_ids,count.index)}"
  backup_policy_id    = "${element(local.backup_policy_ids,count.index)}"
}
