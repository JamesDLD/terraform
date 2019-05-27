#Terraform outputs allow you to define values that will be highlighted to the user when Terraform applies a plan, and can be queried using the terraform output command.
output "log_analytics_workspace_name" {
  value = "${azurerm_log_analytics_workspace.test.name}"
}
