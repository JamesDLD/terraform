output "lb_backend_ids" {
  value = ["${azurerm_lb_backend_address_pool.lb_backend.*.id}"]
}

output "lb_rule_ids" {
  value = ["${azurerm_lb_rule.lb_rule.*.id}"]
}
