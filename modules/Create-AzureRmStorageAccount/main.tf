resource "azurerm_storage_account" "storageaccount" {
  name                     = "${var.sa_name}"
  resource_group_name      = "${var.sa_resource_group_name}"
  location                 = "${var.sa_location}"
  account_replication_type = "${var.sa_account_replication_type}"
  account_tier             = "${var.sa_account_tier}"
  enable_blob_encryption   = true
  enable_file_encryption   = true
  tags                     = "${var.sa_tags}"
}
