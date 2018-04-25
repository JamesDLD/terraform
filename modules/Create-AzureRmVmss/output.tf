output "Linux_Ss_Vms_names" {
  value = "${azurerm_virtual_machine_scale_set.Linux_Ss_Vms.*.name}"
}

output "Linux_Ss_Vms_rgnames" {
  value = "${azurerm_virtual_machine_scale_set.Linux_Ss_Vms.*.resource_group_name}"
}

output "Linux_Ss_Vms_ids" {
  value = "${azurerm_virtual_machine_scale_set.Linux_Ss_Vms.*.id}"
}

output "Windows_Ss_Vms_names" {
  value = "${azurerm_virtual_machine_scale_set.Windows_Ss_Vms.*.name}"
}

output "Windows_Ss_Vms_rgnames" {
  value = "${azurerm_virtual_machine_scale_set.Windows_Ss_Vms.*.resource_group_name}"
}

output "Windows_Ss_Vms_ids" {
  value = "${azurerm_virtual_machine_scale_set.Windows_Ss_Vms.*.id}"
}
