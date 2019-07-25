output "linux_vms_resource_group_names" {
  value = azurerm_virtual_machine.linux_vms.*.resource_group_name
}
output "linux_vms_names" {
  value = azurerm_virtual_machine.linux_vms.*.name
}
output "windows_vms_resource_group_names" {
  value = azurerm_virtual_machine.windows_vms.*.resource_group_name
}
output "windows_vms_names" {
  value = azurerm_virtual_machine.windows_vms.*.name
}
