output "sa_primary_blob_endpoint" {
  value = "${data.azurerm_storage_account.sa.primary_blob_endpoint}"
}
