output "rg_location" {
  value = "${data.azurerm_resource_group.resource_group.location}"
}

output "rg_name" {
  value = "${data.azurerm_resource_group.resource_group.name}"
}

output "rg_tags" {
  value = "${data.azurerm_resource_group.resource_group.tags}"
}

output "rg_id" {
  value = "${data.azurerm_resource_group.resource_group.id}"
}
