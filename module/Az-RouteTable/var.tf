variable "route_tables" {
  description="Route table."
  type = list(object({
    rt_suffix_name = string
  }))
}

variable "routes" {
  description="Routes."
  type = list(object({
    name                   = string
    Id_rt                  = number
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
}

variable "rt_prefix" {
  description="Route table prefix name."
  type=string
}

variable "rt_suffix" {
  description="Route table suffix name."
  type=string
}

variable "rt_location" {
  description="Route table location."
  type=string
}

variable "rt_resource_group_name" {
  description="Route table resource group name."
  type=string
}

variable "rt_tags" {
  description="Route table tags."
  type = map(string)
}

