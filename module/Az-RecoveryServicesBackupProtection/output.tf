/*
Below line was revealing the following error :
Error: Error running plan: 1 error(s) occurred:

* module.Enable-AzureRmRecoveryServicesBackupProtection-Apps.output.rsv_ids: Resource 'azurerm_recovery_services_protected_vm.vm_resources_to_backup' does not have attribute 'id' for variable 'azurerm_recovery_services_protected_vm.vm_resources_to_backup.*.id'

output "rsv_ids" {
  value = ["${azurerm_recovery_services_protected_vm.vm_resources_to_backup.*.id}"]
}
*/

