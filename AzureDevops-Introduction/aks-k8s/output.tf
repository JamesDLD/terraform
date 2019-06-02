#Terraform outputs allow you to define values that will be highlighted to the user when Terraform applies a plan, and can be queried using the terraform output command.
output "provider_kubernetes" {
  value = {
    host                   = azurerm_kubernetes_cluster.demo.kube_config.0.host
    username               = azurerm_kubernetes_cluster.demo.kube_config.0.username
    password               = azurerm_kubernetes_cluster.demo.kube_config.0.password
    client_certificate     = base64decode(azurerm_kubernetes_cluster.demo.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.demo.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.demo.kube_config.0.cluster_ca_certificate)
  }
}
