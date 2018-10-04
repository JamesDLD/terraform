variable "lbs_out" {
  type = "list"
}

variable "lb_out_prefix" {}
variable "lb_out_suffix" {}
variable "lb_out_resource_group_name" {}

variable "lb_out_frontend_ip_configuration_public_ip_address_ids" {
  type = "list"
}

variable "lb_out_backend_ids" {
  type = "list"
}
