variable "nsgs" {
  type = "list"
}

variable "nsg_prefix" {}
variable "nsg_suffix" {}
variable "nsg_location" {}
variable "nsg_resource_group_name" {}

variable "nsg_tags" {
  type = "map"
}

variable "nsgrules" {
  type = "list"
}
