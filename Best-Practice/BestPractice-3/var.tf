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
  description="Subnet list."
  type = list(object({
    name              = string
    cidr_block        = string
    nsg_id            = number                                                                                                                                               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = number                                                                                                                                               #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = number                                                                                                                                                 #Id of the vnet
    service_endpoints = string #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  }))
}

variable "Lbs" {
  description="List containing your load balancers."
  type = list(object({
    suffix_name    = string
    Id_Subnet =  number
    static_ip              = string
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

variable "app_admin" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "pass" {
  description = "Specifies the password of the administrator account on the VM."
}

