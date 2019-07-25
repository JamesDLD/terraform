variable "Lbs" {
  description = "List containing your load balancers."
  type = list(object({
    id               = number
    suffix_name      = string
    subnet_iteration = number
    static_ip        = string
  }))
}

variable "LbRules" {
  description = "List containing your load balancers parameters."
  type = list(object({
    Id                      = number #Id of a the rule within the Load Balancer 
    load_balancer_iteration = number #Id of the Load Balancer
    suffix_name             = string #It must equals the Lbs suffix_name
    lb_port                 = number
    probe_port              = number
    backend_port            = number
    probe_protocol          = string
    request_path            = string
    probe_protocol          = string
    load_distribution       = string
  }))
}
variable "lb_prefix" {
  description = "Prefix applied on the load balancer resources names."
}

variable "lb_location" {
  description = "Location of the load balancer."
}

variable "lb_resource_group_name" {
  description = "Resource group name of the load balancer."
}

variable "Lb_sku" {
  description = "SKU of the load balancer."
}

variable "subnets_ids" {
  description = "A list of subnet ids."
  type        = list(string)
}

variable "lb_tags" {
  description = "Tags of the load balancer."
  type        = map(string)
}

variable "emptylist" {
  type    = list(string)
  default = ["null", "null"]
}
