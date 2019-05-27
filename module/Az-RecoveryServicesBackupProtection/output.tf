output "rsv_ids" {
  value = azurerm_recovery_services_protected_vm.vm_resources_to_backup.*.id
}
