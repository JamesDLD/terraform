output "subnets_ids" {
  value = "${azurerm_subnet.subnets.*.id}"
}
