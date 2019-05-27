output "Linux_Vms_names" {
  value = azurerm_virtual_machine.Linux_Vms.*.name
}

output "Linux_Vms_rgnames" {
  value = azurerm_virtual_machine.Linux_Vms.*.resource_group_name
}

output "Linux_Vms_ids" {
  value = azurerm_virtual_machine.Linux_Vms.*.id
}

output "Windows_Vms_names" {
  value = azurerm_virtual_machine.Windows_Vms.*.name
}

output "Windows_Vms_rgnames" {
  value = azurerm_virtual_machine.Windows_Vms.*.resource_group_name
}

output "Windows_Vms_ids" {
  value = azurerm_virtual_machine.Windows_Vms.*.id
}

