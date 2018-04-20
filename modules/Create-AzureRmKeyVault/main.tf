resource "azurerm_key_vault" "key_vaults" {
  count               = "${length(var.key_vaults)}"
  name                = "${var.kv_prefix}${lookup(var.key_vaults[count.index], "suffix_name")}${var.kv_suffix}"
  location            = "${var.kv_location}"
  resource_group_name = "${var.kv_resource_group_name}"

  sku {
    name = "${var.kv_sku}"
  }

  tenant_id = "${var.kv_tenant_id}"

  access_policy {
    tenant_id = "${lookup(var.key_vaults[count.index], "policy1_tenant_id")}"
    object_id = "${lookup(var.key_vaults[count.index], "policy1_object_id")}"

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]
  }

  enabled_for_disk_encryption = true

  tags = "${var.kv_tags}"
}
