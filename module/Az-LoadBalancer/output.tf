output "lb_names" {
  value = azurerm_lb.lb.*.name
}

output "lb_private_ip_address" {
  value = azurerm_lb.lb.*.private_ip_address
}

output "lb_backend_ids" {
  value = concat(
    azurerm_lb_backend_address_pool.lb_backend.*.id,
    var.emptylist,
  )
}

output "lb_rule_ids" {
  value = azurerm_lb_rule.lb_rule.*.id
}

