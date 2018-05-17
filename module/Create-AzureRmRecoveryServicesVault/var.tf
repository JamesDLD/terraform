variable "rsv_name" {}
variable "rsv_resource_group_name" {}

variable "rsv_tags" {
  type = "map"
}

variable "rsv_backup_policies" {
  type = "list"
}
