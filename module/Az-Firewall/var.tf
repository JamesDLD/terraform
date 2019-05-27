variable "fw_resource_group_name" {
  description="Firewall resource group name."
  type=string
}

variable "fw_location" {
  description="Firewall location."
  type=string
}

variable "fw_prefix" {
  description="Firewall name prefix."
  type=string
}

variable "fw_tags" {
  description="Firewall tags."
  type = map(string)
}

variable "fw_subnet_id" {
  description="Firewall subnet id."
  type=string
}

