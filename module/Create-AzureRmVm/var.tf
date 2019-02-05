variable "sa_bootdiag_storage_uri" {}

variable "Linux_Vms" {
  type = "list"
}

variable "Linux_DataDisks" {
  type = "list"
}

variable "Windows_DataDisks" {
  type = "list"
}

variable "Windows_Vms" {
  type = "list"
}

variable "vm_location" {}
variable "vm_resource_group_name" {}
variable "vm_prefix" {}

variable "vm_tags" {
  type = "map"
}

variable "app_admin" {}
variable "pass" {}
variable "ssh_key" {}

variable "Linux_nics_ids" {
  type = "list"
}

variable "Windows_nics_ids" {
  type = "list"
}

variable "Linux_storage_image_reference" {
  type        = "list"
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "Windows_storage_image_reference" {
  type        = "list"
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}
