output "auto_acc_id" {
  value = "${azurerm_automation_account.auto_acc.name}"
}

/*
output "ava_set_names" {
  value = ["${azurerm_availability_set.ava_set.*.name}"]
}
*/

