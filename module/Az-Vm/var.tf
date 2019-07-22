

variable "sa_bootdiag_storage_uri" {
  type        = string
  description = "Azure Storage Account Primary Queue Service Endpoint."
}

variable "linux_storage_image_reference" {
  type        = map(string)
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "Latest"
  }
}

variable "vms" {
  description = "VMs list."
  type        = any
}

variable "windows_storage_image_reference" {
  type        = map(string)
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "Latest"
  }
}
variable "vm_location" {
  description = "VM's location."
}

variable "vm_resource_group_name" {
  description = "VM's resource group name."
}

variable "vm_prefix" {
  description = "Prefix used for the VM, Disk and Nic names."
}

variable "vm_tags" {
  description = "Tags pushed on the VM, Disk and Nic."
  type        = map(string)
}

variable "admin_username" {
  description = "Specifies the name of the local administrator account."
}

variable "admin_password" {
  description = "The password associated with the local administrator account."
}

variable "ssh_key" {
  description = "(Optional) One or more ssh_keys blocks. This field is required if disable_password_authentication is set to true."
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMelxhig6IY80GykqTf0wkozE860GPkd7RU5231b2UEMVyj1BBiPwTYCbAzY/8xBNyz9VL5uzjM6+S9N+OpIZKAMITzU1IVGzo7DtucNwKkRZ6egq+kfFG2JiKs945XOB6xhfFbzoneBu++yEToOrNLHM9Eu5eFFS07Ow+I2YIrTPpfw/UZCNUGFZun2iwm9MkKSWrBR8+/kE54WOAbrGq9symayBvD1A3aHBJ3HPL/geIzNAWw4y6YYsaCWOht1pVMfxf+LSf42XKJ/T8HjO0Ea2lKq5Nmh5cv5aKm6nVprF/L6SlQ3dNSUYPprnDiDBlPBGaBvtz2Hj0sseiu0YH"
}

variable "key_vault_id" {
  description = "Key vault id to store VM certificates."
}

variable "disable_log_analytics_dependencies" {
}

variable "workspace_resource_group_name" {
}

variable "workspace_name" {
}

variable "OmsAgentForLinux" {
  type = map(string)
  default = {
    publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
    type                       = "OmsAgentForLinux"
    type_handler_version       = "1.9" #https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-linux
    auto_upgrade_minor_version = "true"
  }
}

variable "DependencyAgentLinux" {
  type = map(string)
  default = {
    publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
    type                       = "DependencyAgentLinux"
    type_handler_version       = "9.5"
    auto_upgrade_minor_version = "true"
  }
}

variable "DependencyAgentWindows" {
  type = map(string)
  default = {
    publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
    type                       = "DependencyAgentWindows"
    type_handler_version       = "9.5"
    auto_upgrade_minor_version = "true"
  }
}

variable "OmsAgentForWindows" {
  type = map(string)
  default = {
    publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
    type                       = "MicrosoftMonitoringAgent"
    type_handler_version       = "1.0" #https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-windows
    auto_upgrade_minor_version = "true"
  }
}
variable "subnets_ids" {
  description = "Network Interfaces subnets list."
  type        = list(string)
}

variable "internal_lb_backend_ids" {
  description = "Network Interfaces internal load balancers backend ids list."
  type        = list(string)
}

variable "public_lb_backend_ids" {
  description = "Network Interfaces public load balancers backend ids list."
  type        = list(string)
}

variable "nsgs_ids" {
  description = "Network Interfaces network security ids."
  type        = list(string)
}

variable "public_ip_ids" {
  description = "Network Interfaces public ip ids."
  type        = list(string)
}
