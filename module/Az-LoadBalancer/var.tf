variable "Lbs" {

}

variable "lb_prefix" {
}

variable "lb_suffix" {
}

variable "lb_location" {
}

variable "lb_resource_group_name" {
}

variable "Lb_sku" {
}

variable "subnets_ids" {
  type = list(string)
}

variable "lb_tags" {
  type = map(string)
}

variable "LbRules" {

}

variable "emptylist" {
  type    = list(string)
  default = ["null", "null"]
}

