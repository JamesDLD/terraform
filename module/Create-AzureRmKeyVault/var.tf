variable "key_vaults" {
  type = list
}

variable "kv_prefix" {}
variable "kv_suffix" {}
variable "kv_location" {}
variable "kv_resource_group_name" {}
variable "kv_sku" {}
variable "kv_tenant_id" {}

variable "kv_tags" {
  type = "map"
}
