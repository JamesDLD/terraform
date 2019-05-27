output "kv_ids" {
  value = azurerm_key_vault.key_vaults.*.id
}

output "kv_vault_uri" {
  value = azurerm_key_vault.key_vaults.*.vault_uri
}
