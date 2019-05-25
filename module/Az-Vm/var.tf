variable "subscription_id" {
  type=string
  description="Azure subscription Id."
}

variable "sa_bootdiag_storage_uri" {
  type=string
  description="Azure Storage Account Primary Queue Service Endpoint."
}

variable "Linux_Vms" {
  description="Linux VMs list."
  type = list(object({
    suffix_name                   = string
    id                            = number               #Id of the VM
    Id_Lb                         = number               #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = number             #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = number             #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = number               #Id of the Subnet
    zone                          = number               #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = number             #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = string             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = string        #Set 777 to get dynamic IP
    vm_size                       = string
    managed_disk_type             = string
    enable_accelerated_networking = bool
  }))
}

variable "Linux_DataDisks" {
  description="Linux DataDisks VM's Data disks."
  type = list(object({
    id                = number           #Id of the VM from the upper list
    suffix_name       = string        #MUST match the VM suffix_name + the id of the VM
    id_disk           = number           #Id of the disk
    zone              = number           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to ""
    managed_disk_type = string
    lun               = number
    disk_size_gb      = number
    caching           = string
  }))
}
variable "Linux_storage_image_reference" {
  type        = map(string)
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}

variable "Windows_Vms" {
  description="Linux VMs list."
  type = list(object({
    suffix_name                   = string
    id                            = number               #Id of the VM
    Id_Lb                         = number               #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = number             #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = number             #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = number               #Id of the Subnet
    zone                          = number               #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = number             #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = string             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = string        #Set 777 to get dynamic IP
    vm_size                       = string
    managed_disk_type             = string
    enable_accelerated_networking = bool
  }))
}
variable "Windows_DataDisks" {
  description="Windows DataDisks VM's Data disks."
  type = list(object({
    id                = number           #Id of the VM from the upper list
    suffix_name       = string        #MUST match the VM suffix_name + the id of the VM
    id_disk           = number           #Id of the disk
    zone              = number           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to ""
    managed_disk_type = string
    lun               = number
    disk_size_gb      = number
    caching           = string
  }))
}
variable "Windows_storage_image_reference" {
  type        = map(string)
  description = "Could containt an 'id' of a custom image or the following parameters for an Azure public 'image publisher','offer','sku', 'version'"
}
variable "vm_location" {
}

variable "vm_resource_group_name" {
}

variable "vm_prefix" {
}

variable "vm_tags" {
  type = map(string)
}

variable "app_admin" {
}

variable "pass" {
}

variable "ssh_key" {
}

variable "Linux_nics_ids" {
  type = list(string)
}

variable "Windows_nics_ids" {
  type = list(string)
}

variable "key_vault_id" {
  description = "Key vault id to store VM certificates."
}

variable "disable_password_authentication" {
  default = "true"
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
/*
variable "Windows_DataDisks" {
  description="Windows DataDisks VM's Data disks."
  type = list(object({
    id                = number           #Id of the VM from the upper list
    suffix_name       = string        #MUST match the VM suffix_name + the id of the VM
    id_disk           = number           #Id of the disk
    zone              = number           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to ""
    managed_disk_type = string
    lun               = number
    disk_size_gb      = number
    caching           = string
  }))
}
*/