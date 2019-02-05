resource "azurerm_availability_set" "ava_set" {
  count                        = "${length(var.ava_availabilitysets)}"
  name                         = "${var.ava_prefix}${lookup(var.ava_availabilitysets[count.index], "suffix_name")}${var.ava_suffix}"
  platform_fault_domain_count  = "${lookup(var.ava_availabilitysets[count.index], "platform_fault_domain_count")}"
  platform_update_domain_count = "${lookup(var.ava_availabilitysets[count.index], "platform_fault_domain_count")}"
  location                     = "${var.ava_location}"
  resource_group_name          = "${var.ava_resource_group_name}"
  managed                      = true
  tags                         = "${var.ava_tags}"
}
