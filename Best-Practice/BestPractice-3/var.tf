#Variables declaration

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "client_id" {
  description = "Azure service principal application Id"
}

variable "client_secret" {
  description = "Azure service principal application Secret"
}

variable "subnets" {
  type        = "list"
  description = "Subnet list"
}

variable "Lbs" {
  type        = "list"
  description = "Load Balancer list containing the following keys : suffix_name, Id_Subnet, static_ip."
}

variable "Windows_Vms" {
  type        = "list"
  description = "Windows VM list"
}

variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
}
