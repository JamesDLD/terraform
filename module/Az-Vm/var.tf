variable "subscription_id" {}
variable "sa_bootdiag_storage_uri" {}

variable "Linux_Vms" {
  type = "list"
}

variable "Linux_DataDisks" {
  type = "list"
}

variable "Windows_DataDisks" {
  type = "list"
}

variable "Windows_Vms" {
  type = "list"
}

variable "vm_location" {}
variable "vm_resource_group_name" {}
variable "vm_prefix" {}

variable "vm_tags" {
  type = "map"
}

variable "app_admin" {}
variable "pass" {}
variable "ssh_key" {}

variable "Linux_nics_ids" {
  type = "list"
}

variable "Windows_nics_ids" {
  type = "list"
}

variable "Linux_storage_image_reference" {
  type        = "list"
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "Windows_storage_image_reference" {
  type        = "list"
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "key_vault_id" {
  description = "Key vault id to store VM certificates."
}

variable "disable_password_authentication" {
  default = "true"
}

variable "disable_log_analytics_dependencies" {}
variable "workspace_resource_group_name" {}
variable "workspace_name" {}

variable "OmsAgentForLinux" {
  type = "list"

  default = [
    {
      publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
      type                       = "OmsAgentForLinux"
      type_handler_version       = "1.9"                                  #https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-linux
      auto_upgrade_minor_version = "true"
    },
  ]
}

variable "DependencyAgentLinux" {
  type = "list"

  default = [
    {
      publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
      type                       = "DependencyAgentLinux"
      type_handler_version       = "9.5"
      auto_upgrade_minor_version = "true"
    },
  ]
}

variable "DependencyAgentWindows" {
  type = "list"

  default = [
    {
      publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
      type                       = "DependencyAgentWindows"
      type_handler_version       = "9.5"
      auto_upgrade_minor_version = "true"
    },
  ]
}

variable "OmsAgentForWindows" {
  type = "list"

  default = [
    {
      publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
      type                       = "MicrosoftMonitoringAgent"
      type_handler_version       = "1.0"                                  #https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-windows
      auto_upgrade_minor_version = "true"
    },
  ]
}
