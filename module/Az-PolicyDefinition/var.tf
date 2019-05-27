variable "policies" {
  description="Policies."
  type = list(object({
    suffix_name         = string #Used to name the policy and to call json template files located into the module's folder
    policy_type          = string
    mode = string
  }))
}

variable "pol_prefix" {
  description="Policy name prefix."
  type=string
}

variable "pol_suffix" {
  description="Policy name prefix."
  type=string
}

