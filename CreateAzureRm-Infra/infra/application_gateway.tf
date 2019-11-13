
/*
resource "azurerm_public_ip" "infra" {
  name                = "appgateway1-pip1"
  resource_group_name = data.azurerm_resource_group.Infr.name
  location            = data.azurerm_resource_group.Infr.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "infra-beap"
  frontend_port_name             = "infra-feport"
  frontend_ip_configuration_name = "infra-feip"
  http_setting_name              = "infra-be-htst"
  listener_name                  = "infra-httplstn"
  request_routing_rule_name      = "infra-rqrt"
  redirect_configuration_name    = "infra-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "appgateway1"
  resource_group_name = data.azurerm_resource_group.Infr.name
  location            = data.azurerm_resource_group.Infr.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgateway1-CFG"
    subnet_id = element(module.Az-VirtualNetwork-Infra.subnet_ids, 1)
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.infra.id}"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }
}
*/
