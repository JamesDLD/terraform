variable "auto_name" {}
variable "auto_location" {}
variable "auto_resource_group_name" {}
variable "auto_sku" {}

variable "auto_tags" {
  type = "map"
}

variable "auto_credentials" {
  type = "list"
}
