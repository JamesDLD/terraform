#Call module/resource
###
# Use Log Monitor with AKS
###
resource "azurerm_log_analytics_workspace" "demo" {
  name                = var.log_analytics_workspace["name"]
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  sku                 = var.log_analytics_workspace["sku"]
  tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_log_analytics_solution" "demo" {
  count                 = length(var.log_analytics_workspace.solutions)
  solution_name         = var.log_analytics_workspace.solutions[count.index]["name"]
  location              = azurerm_log_analytics_workspace.demo.location
  resource_group_name   = data.azurerm_resource_group.Infr.name
  workspace_resource_id = azurerm_log_analytics_workspace.demo.id
  workspace_name        = azurerm_log_analytics_workspace.demo.name

  plan {
    publisher = var.log_analytics_workspace.solutions[count.index]["publisher"]
    product   = var.log_analytics_workspace.solutions[count.index]["product"]
  }
}

###
# Store the Kubernetes AKS cluster credential in the Key Vault
###
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo" {
  name                = var.key_vault["name"]
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault["sku"]

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.service_principal_object_id

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]
  }

  tags = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_key_vault_secret" "demo" {
  name         = "providerkubernetes"
  value        = azurerm_kubernetes_cluster.demo.kube_config.0.password
  key_vault_id = azurerm_key_vault.demo.id

  tags = {
    host     = "${azurerm_kubernetes_cluster.demo.kube_config.0.host}"
    username = "${azurerm_kubernetes_cluster.demo.kube_config.0.username}"
    #client_certificate     = "${base64decode(azurerm_kubernetes_cluster.demo.kube_config.0.client_certificate)}"
    #client_key             = "${base64decode(azurerm_kubernetes_cluster.demo.kube_config.0.client_key)}"
    #cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.demo.kube_config.0.cluster_ca_certificate)}"
  }
}
