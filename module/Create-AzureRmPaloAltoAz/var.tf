variable "pac_resource_group_name" {
  description = "Palo Alto resource group name."
}

variable "pac" {
  type        = "list"
  description = "Palo Alto properties."
}

variable "pac_tags" {
  type        = "map"
  description = "AzureRm tags."
}

variable "pac_virtual_network_name" {
  description = "Palo Alto virtual network name."
}

variable "pac_virtual_network_resource_group_name" {
  description = "Palo Alto virtual network resource group name."
}

variable "adminUsername" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "adminPassword" {
  description = "Specifies the password of the administrator account on the VM."
}

variable "pac_nsg_name" {
  description = "Name of existing Network Security Group for MGMT FW interface."
}

variable "boot_diag_storage_account_name" {
  description = "Storage account where will be stored the boot diagnostic files."
}
