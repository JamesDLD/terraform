variable "roles" {
  description="Roles list."
  type = list(object({
    suffix_name         = string 
    actions          = string
    not_actions = string
  }))
}

variable "role_prefix" {
  description="Role name prefix."
  type=string
}

variable "role_suffix" {
  description="Role name suffix."
  type=string
}

