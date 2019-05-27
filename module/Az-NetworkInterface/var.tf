variable "subscription_id" {
  description="Azure subscription Id."
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

variable "nic_suffix" {
  description="Network Interfaces suffix."
}

variable "nic_prefix" {
  description="Network Interfaces prefix."
}

variable "nic_location" {
  description="Network Interfaces location."
}

variable "nic_resource_group_name" {
  description="Network Interfaces resource group name."
}

variable "subnets_ids" {
  description="Network Interfaces subnets list."
  type = list(string)
}

variable "lb_backend_ids" {
  description="Network Interfaces internal load balancers backend ids list."
  type = list(string)
}

variable "lb_backend_Public_ids" {
  description="Network Interfaces public load balancers backend ids list."
  type = list(string)
}

variable "nic_tags" {
  description="Network Interfaces tags."
  type = map(string)
}

variable "nsgs_ids" {
  description="Network Interfaces network security ids."
  type = list(string)
}

