
variable "location" {
  type        = string
  description = "Location of the Bastion."
}

variable "resourceGroupName" {
  type        = string
  description = "Resource group name of the Bastion."
}

variable "bastionHostName" {
  type        = string
  description = "Name of the Bastion."
}

variable "subnetName" {
  type        = string
  description = "Subnet name of the Bastion."
  default     = "AzureBastionSubnet"
}

variable "publicIpAddressName" {
  type        = string
  description = "Public IP address name."
}

variable "existingVNETName" {
  type        = string
  description = "Vnet name of the Bastion."
}

variable "subnetAddressPrefix" {
  type        = string
  description = "Subnet prefix that is dedicated to the Bastion."
}

variable "tags" {
  type        = map(string)
  description = "Tags of the bastion."
}
