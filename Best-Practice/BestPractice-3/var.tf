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
  type        = list
  description = "Subnet list"
}

variable "Lbs" {
  type        = list
  description = "Load Balancer list containing the following keys : suffix_name, Id_Subnet, static_ip."
}

variable "Windows_Vms" {
  type        = list
  description = "Windows VM list"
}

variable "Windows_DataDisks" {
  type        = list
  description = "Data disk list."
}

variable "Windows_storage_image_reference" {
  type        = list
  description = "Could contain an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
}

