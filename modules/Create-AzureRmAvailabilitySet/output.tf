output "ava_set_ids" {
  value = ["${azurerm_availability_set.ava_set.*.id}"]
}

output "ava_set_names" {
  value = ["${azurerm_availability_set.ava_set.*.name}"]
}
