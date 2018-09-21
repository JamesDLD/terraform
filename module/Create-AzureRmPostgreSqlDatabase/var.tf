variable "pgsql_prefix" {}
variable "pgsql_suffix" {}

variable "pgsql_server" {
  type = "list"
}

variable "pgsql_administrator_login" {}
variable "pgsql_administrator_password" {}

variable "pgsql_config" {
  type = "list"
}

variable "pgsql_db_firewall" {
  type = "list"
}

variable "pgsql_db" {
  type = "list"
}

variable "pgsql_resource_group_name" {}
variable "pgsql_location" {}

variable "pgsql_subnet_id" {}
