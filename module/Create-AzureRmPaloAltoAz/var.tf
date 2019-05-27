variable "pac_resource_group_name" {
  description = "Palo Alto resource group name."
}

variable "pac" {
  description = "Palo Alto properties."
  type = list(object({
      suffix_name                   = string
      suffix_pip_domainNameLabel    = string
      id                            = string
      vmAvailabilityZone            = string
      vmSize                        = string
      vmImageVersion                = string
      vmImagePublisher              = string
      vmImageOffer                  = string
      vmImageSku                    = string
      vm_managed_disk_type          = string
      enable_accelerated_networking = string
      subnet_mgmt_name              = string
      subnet_untrust_name           = string
      subnet_trust_name             = string
      subnet_mgmt_ip                = string
      subnet_untrust_ip             = string
      subnet_trust_ip               = string
  }))
}

variable "pac_tags" {
  type        = map(string)
  description = "AzureRm tags."
}

variable "pac_virtual_network_name" {
  description = "Palo Alto virtual network name."
}

variable "pac_virtual_network_resource_group_name" {
  description = "Palo Alto virtual network resource group name."
}

variable "adminUsername" {
  description = "Specifies the name of the administrator account on the VM."
}

variable "adminPassword" {
  description = "Specifies the password of the administrator account on the VM."
}

variable "pac_nsg_name" {
  description = "Name of existing Network Security Group for MGMT FW interface."
}

variable "boot_diag_storage_account_name" {
  description = "Storage account where will be stored the boot diagnostic files."
}

