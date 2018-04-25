output "asgs_ids" {
  value = "${azurerm_application_security_group.asgs.*.id}"
}
