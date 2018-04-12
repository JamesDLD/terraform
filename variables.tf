#Variables declaration

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "app_name" {}
variable "env_name" {}

variable "sa_account_replication_type" {}
variable "sa_account_tier" {}

variable "rg_apps_name" {}
variable "sa_apps_name" {}
variable "rg_infr_name" {}
variable "sa_infr_name" {}

variable "location" {}

variable "default_tags" {
  type = "map"
}

variable "backup_policies" {
  type = "list"
}
