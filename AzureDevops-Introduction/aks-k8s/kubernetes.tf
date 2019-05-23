/*
#Call module/resource

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "agentpool"
    count           = "${var.agent_count}"
    vm_size         = "Standard_DS1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${azurerm_log_analytics_workspace.test.id}"
    }
  }

  tags = "${data.azurerm_resource_group.Infr.tags}"
}
*/

