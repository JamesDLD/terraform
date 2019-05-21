#Call module/resource

resource "azurerm_log_analytics_workspace" "test" {
  name                = "${var.log_analytics_workspace_name}"
  location            = "${data.azurerm_resource_group.Infr.location}"
  resource_group_name = "${data.azurerm_resource_group.Infr.name}"
  sku                 = "${var.log_analytics_workspace_sku}"
  tags                = "${data.azurerm_resource_group.Infr.tags}"
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = "${azurerm_log_analytics_workspace.test.location}"
  resource_group_name   = "${data.azurerm_resource_group.Infr.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.test.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.test.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
