output "sa_id" {
  value = "${azurerm_storage_account.storageaccount.id}"
}

output "sa_primary_blob_endpoint" {
  value = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}"
}
