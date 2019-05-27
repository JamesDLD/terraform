resource "azurerm_key_vault" "key_vaults" {
  count                           = "${length(var.key_vaults)}"
  name                            = "${var.kv_prefix}${var.key_vaults[count.index]["suffix_name"]}${var.kv_suffix}"
  location                        = "${var.kv_location}"
  resource_group_name             = "${var.kv_resource_group_name}"
  tenant_id                       = "${var.kv_tenant_id}"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  sku {
    name = "${var.kv_sku}"
  }

  tags = "${var.kv_tags}"

  access_policy {
    tenant_id      = var.key_vaults[count.index]["policy1_tenant_id"]
    object_id      = var.key_vaults[count.index]["policy1_object_id"]
    application_id = var.key_vaults[count.index]["policy1_application_id"]

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
}
