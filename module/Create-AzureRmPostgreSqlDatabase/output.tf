output "pg_server_id" {
  value = "${azurerm_postgresql_server.pgsql_server.*.id}"
}

output "pg_server_name" {
  value = "${azurerm_postgresql_server.pgsql_server.*.name}"
}

output "pg_admin_login" {
  value = "${azurerm_postgresql_server.pgsql_server.*.administrator_login}"
}

output "pg_config_id" {
  value = "${azurerm_postgresql_configuration.postgresql_config.*.id}"
}

output "pg_config_name" {
  value = "${azurerm_postgresql_configuration.postgresql_config.*.name}"
}

output "pg_config_value" {
  value = "${azurerm_postgresql_configuration.postgresql_config.*.value}"
}

output "pg_db_id" {
  value = "${azurerm_postgresql_database.postgresql_database.*.id}"
}

output "pg_db_name" {
  value = "${azurerm_postgresql_database.postgresql_database.*.name}"
}

output "pg_db_charset" {
  value = "${azurerm_postgresql_database.postgresql_database.*.charset}"
}

output "pg_db_collation" {
  value = "${azurerm_postgresql_database.postgresql_database.*.collation}"
}

output "pg_fw_id" {
  value = "${azurerm_postgresql_firewall_rule.postgresql_firewall_rule.*.id}"
}

output "pg_fw_name" {
  value = "${azurerm_postgresql_firewall_rule.postgresql_firewall_rule.*.name}"
}
