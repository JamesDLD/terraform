resource "azurerm_network_security_group" "nsgs" {
  count               = length(var.nsgs)
  name                = "${var.nsg_prefix}${var.nsgs[count.index]["suffix_name"]}${var.nsg_suffix}"
  location            = var.nsg_location
  resource_group_name = var.nsg_resource_group_name
  tags                = var.nsg_tags

  dynamic "security_rule" {
  for_each = var.nsgs[count.index].rules
    content {
      description      = lookup(security_rule.value, "description", null)
      direction        = lookup(security_rule.value, "direction", null)
      name     = lookup(security_rule.value, "name", null)
      access        = lookup(security_rule.value, "access", null)
      priority     = lookup(security_rule.value, "priority", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes        = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix     = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes     = lookup(security_rule.value, "destination_address_prefixes", null)
      destination_port_range        = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges        = lookup(security_rule.value, "destination_port_ranges", null)
      protocol     = lookup(security_rule.value, "protocol", null)
      source_port_range        = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges        = lookup(security_rule.value, "source_port_ranges", null)
    }
  }
}