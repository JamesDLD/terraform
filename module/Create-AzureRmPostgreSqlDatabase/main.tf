resource "azurerm_postgresql_server" "pgsql_server" {
  count               = "${length(var.pgsql_server)}"
  name                = "${var.pgsql_prefix}${lookup(var.pgsql_server[count.index], "suffix_name")}${var.pgsql_suffix}"
  resource_group_name = "${var.pgsql_resource_group_name}"
  location            = "${var.pgsql_location}"

  sku {
    name     = "${lookup(var.pgsql_server[count.index], "sku_name")}"
    capacity = "${lookup(var.pgsql_server[count.index], "sku_capacity")}"
    tier     = "${lookup(var.pgsql_server[count.index], "sku_tier")}"
    family   = "${lookup(var.pgsql_server[count.index], "sku_family")}"
  }

  ssl_enforcement = "${lookup(var.pgsql_server[count.index], "ssl_enforcement")}"

  storage_profile {
    storage_mb            = "${lookup(var.pgsql_server[count.index], "storage_mb")}"
    backup_retention_days = "${lookup(var.pgsql_server[count.index], "backup_retention_days")}"
    geo_redundant_backup  = "${lookup(var.pgsql_server[count.index], "geo_redundant_backup")}"
  }

  administrator_login          = "${var.pgsql_administrator_login}"
  administrator_login_password = "${var.pgsql_administrator_password}"
  version                      = "${lookup(var.pgsql_server[count.index], "version")}"
}

resource "azurerm_postgresql_database" "postgresql_database" {
  count               = "${ "${length(var.pgsql_server)}" == "0" ? "0" : "${length(var.pgsql_db)}" }"
  name                = "${lookup(var.pgsql_db[count.index], "suffix_name")}db${lookup(var.pgsql_db[count.index], "id")}"
  resource_group_name = "${element(azurerm_postgresql_server.pgsql_server.*.resource_group_name,lookup(var.pgsql_db[count.index], "id_server"))}"
  server_name         = "${element(azurerm_postgresql_server.pgsql_server.*.name,lookup(var.pgsql_db[count.index], "id_server"))}"
  charset             = "${lookup(var.pgsql_db[count.index], "charset")}"
  collation           = "${lookup(var.pgsql_db[count.index], "collation")}"
}

resource "azurerm_postgresql_firewall_rule" "postgresql_firewall_rule" {
  count               = "${ "${length(var.pgsql_server)}" == "0" ? "0" : "${length(var.pgsql_db_firewall)}" }"
  resource_group_name = "${element(azurerm_postgresql_server.pgsql_server.*.resource_group_name,lookup(var.pgsql_db_firewall[count.index], "id_server"))}"
  server_name         = "${element(azurerm_postgresql_server.pgsql_server.*.name,lookup(var.pgsql_db_firewall[count.index], "id_server"))}"
  name                = "fwrule-${lookup(var.pgsql_db_firewall[count.index], "id")}"
  start_ip_address    = "${lookup(var.pgsql_db_firewall[count.index], "start_ip")}"
  end_ip_address      = "${lookup(var.pgsql_db_firewall[count.index], "end_ip")}"
}

resource "azurerm_postgresql_configuration" "postgresql_config" {
  count               = "${ "${length(var.pgsql_server)}" == "0" ? "0" : "${length(var.pgsql_config)}" }"
  name                = "${lookup(var.pgsql_config[count.index], "PostgreSQLName")}"
  resource_group_name = "${element(azurerm_postgresql_server.pgsql_server.*.resource_group_name,lookup(var.pgsql_config[count.index], "id_server"))}"
  server_name         = "${element(azurerm_postgresql_server.pgsql_server.*.name,lookup(var.pgsql_config[count.index], "id_server"))}"
  value               = "${lookup(var.pgsql_config[count.index], "value")}"
}

/*
resource "azurerm_postgresql_virtual_network_rule" "vnet_rules" {
  count               = "${length(var.pgsql_server)}"
  name                = "${var.pgsql_prefix}${lookup(var.pgsql_server[count.index], "suffix_name")}${var.pgsql_suffix}-vnetrule"
  server_name         = "${element(azurerm_postgresql_server.pgsql_server.*.name,count.index)}"
  resource_group_name = "${element(azurerm_postgresql_server.pgsql_server.*.resource_group_name,count.index)}"
  subnet_id           = "${var.pgsql_subnet_id}"
}
*/

