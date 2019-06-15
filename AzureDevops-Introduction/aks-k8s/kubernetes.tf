#Call module/resource
resource "azurerm_kubernetes_cluster" "demo" {
  name                = var.kubernetes_cluster["name"]
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  dns_prefix          = var.kubernetes_cluster["dns_prefix"]

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.demo.id
    }
  }

  tags = data.azurerm_resource_group.Infr.tags
}

