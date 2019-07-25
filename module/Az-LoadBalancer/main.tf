resource "azurerm_lb" "lb" {
  count               = length(var.Lbs)
  name                = "${var.lb_prefix}${var.Lbs[count.index]["suffix_name"]}${var.lb_suffix}"
  location            = var.lb_location
  resource_group_name = var.lb_resource_group_name
  sku                 = var.Lb_sku

  frontend_ip_configuration {
    name                          = "${var.lb_prefix}${var.Lbs[count.index]["suffix_name"]}-nic1-LBCFG"
    subnet_id                     = element(var.subnets_ids, var.Lbs[count.index]["subnet_iteration"])
    private_ip_address_allocation = var.Lbs[count.index]["static_ip"] == "777" ? "dynamic" : "static"
    private_ip_address            = var.Lbs[count.index]["static_ip"] == "777" ? "" : var.Lbs[count.index]["static_ip"]
  }

  tags = var.lb_tags
}

resource "azurerm_lb_backend_address_pool" "lb_backend" {
  count               = length(var.Lbs)
  resource_group_name = var.lb_resource_group_name
  loadbalancer_id     = element(azurerm_lb.lb.*.id, count.index)
  name                = "${var.lb_prefix}${var.Lbs[count.index]["suffix_name"]}-bckpool1"
}

resource "azurerm_lb_probe" "lb_probe" {
  count               = length(var.LbRules)
  resource_group_name = var.lb_resource_group_name
  loadbalancer_id     = element(azurerm_lb.lb.*.id, var.LbRules[count.index]["Id_Lb"])
  name                = "${var.lb_prefix}${var.LbRules[count.index]["suffix_name"]}-probe${var.LbRules[count.index]["Id"]}"
  port                = var.LbRules[count.index]["probe_port"]
  protocol            = var.LbRules[count.index]["probe_protocol"]
  request_path        = var.LbRules[count.index]["probe_protocol"] == "Tcp" ? "" : var.LbRules[count.index]["request_path"]
}

resource "azurerm_lb_rule" "lb_rule" {
  count                          = length(var.LbRules)
  resource_group_name            = var.lb_resource_group_name
  loadbalancer_id                = element(azurerm_lb.lb.*.id, var.LbRules[count.index]["Id_Lb"])
  name                           = "${var.lb_prefix}${var.LbRules[count.index]["suffix_name"]}-rule${var.LbRules[count.index]["Id"]}"
  protocol                       = "Tcp"
  frontend_port                  = var.LbRules[count.index]["lb_port"]
  backend_port                   = var.LbRules[count.index]["backend_port"]
  frontend_ip_configuration_name = "${var.lb_prefix}${var.LbRules[count.index]["suffix_name"]}-nic1-LBCFG"
  backend_address_pool_id = element(
    azurerm_lb_backend_address_pool.lb_backend.*.id,
    var.LbRules[count.index]["Id_Lb"],
  )
  probe_id                = element(azurerm_lb_probe.lb_probe.*.id, count.index)
  load_distribution       = var.LbRules[count.index]["load_distribution"]
  idle_timeout_in_minutes = 4
}

