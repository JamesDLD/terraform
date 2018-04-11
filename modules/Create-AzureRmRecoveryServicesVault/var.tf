variable "app_name" {}
variable "env_name" {}
variable "location" {}
variable "rg_apps_name" {}
variable subscription_id {}

variable "default_tags" {
  type = "map"
}

variable "recovery_service_vaults" {
  type = "list"
}

variable "backup_policies" {
  type = "list"
}

variable "vms_ids" {
  type = "list"
}

variable "Vms" {
  type = "list"
}
