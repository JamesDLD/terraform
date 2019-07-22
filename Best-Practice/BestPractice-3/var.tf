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
  description = "Subnet list."
  type = list(object({
    name              = string
    cidr_block        = string
    nsg_id            = number #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = number #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = number #Id of the vnet
    service_endpoints = string #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  }))
}

variable "Lbs" {
  description = "List containing your load balancers."
  type = list(object({
    suffix_name = string
    Id_Subnet   = number
    static_ip   = string
  }))
}
variable "vms" {
  description = "VMs list."
  type        = any
}

variable "windows_storage_image_reference" {
  type        = map(string)
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
}

