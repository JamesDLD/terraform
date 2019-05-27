variable "nsgs" {
  description="Network Security Groups list."
  type = list(object({
    suffix_name                   = string
  }))
}

variable "nsgrules" {
  description="Network Security Group's rules list."
  type = list(object({
    Id_Nsg                     = number                   #Id of the apps Network Security Group
    direction                  = string
    suffix_name                = string
    access                     = string
    priority                   = number
    source_address_prefix      = string
    destination_address_prefix = string
    destination_port_range     = string
    protocol                   = string
    source_port_range          = string
  }))
}

variable "nsg_prefix" {
}

variable "nsg_suffix" {
}

variable "nsg_location" {
}

variable "nsg_resource_group_name" {
}

variable "nsg_tags" {
  type = map(string)
}

