Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

#Set authentication variables
variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "client_id" {
  description = "Azure service principal application Id."
}

variable "client_secret" {
  description = "Azure service principal application Secret."
}

#Set resource variables

variable "virtual_networks" {
  default = [
    {
      id            = "1"
      prefix        = "demovm"
      address_space = ["10.0.128.0/24", "198.18.2.0/24"]
      bastion       = false
    },
  ]
}

variable "subnets" {
  default = [
    {
      virtual_network_iteration = "0"             #(Mandatory) 
      name                      = "demo1"         #(Mandatory) 
      address_prefix            = "10.0.128.0/28" #(Mandatory) 
    },
    {
      virtual_network_iteration = "0"              #(Mandatory) 
      name                      = "demo2"          #(Mandatory) 
      address_prefix            = "10.0.128.16/28" #(Mandatory) 
    },
  ]
}

variable "Lbs" {
  default = [
    {
      suffix_name = "demovm" #It must equals the Vm suffix_name
      Id_Subnet   = "0"      #Id of the Subnet
      static_ip   = "10.0.128.5"
    },
  ]
}

variable "vms" {
  default = [
    {
      suffix_name          = "nva"             #(Mandatory) suffix of the vm
      id                   = "1"               #(Mandatory) Id of the VM
      os_type              = "linux"           #(Mandatory) Support "linux" or "windows"
      storage_data_disks   = []                #(Mandatory) For no data disks set []
      subnet_iteration     = "1"               #(Mandatory) Id of the Subnet
      zones                = ["1"]             #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
      vm_size              = "Standard_DS1_v2" #(Mandatory) 
      managed_disk_type    = "Premium_LRS"     #(Mandatory) 
      enable_ip_forwarding = true              #(Optiona)
    },
    {
      suffix_name = "rdg"   #(Mandatory) suffix of the vm
      id          = "1"     #(Mandatory)Id of the VM
      os_type     = "linux" #(Mandatory) Support "linux" or "windows"
      storage_data_disks = [
        {
          id                = "1" #Disk id
          lun               = "0"
          disk_size_gb      = "32"
          managed_disk_type = "Premium_LRS"
          caching           = "ReadWrite"
          create_option     = "Empty"
        },
      ]                                                 #(Mandatory) For no data disks set []
      internal_lb_iteration         = "0"               #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
      public_lb_iteration           = null              #(Optional) Id of the public Load Balancer, set to null or delete the line if there is no public Load Balancer
      public_ip_iteration           = null              #(Optional) Id of the public Ip, set to null if there is no public Ip
      subnet_iteration              = "0"               #(Mandatory) Id of the Subnet
      zones                         = ["1"]             #(Optional) Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
      security_group_iteration      = null              #(Optional) Id of the Network Security Group, set to null if there is no Network Security Groups
      BackupPolicyName              = null              #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
      static_ip                     = "10.0.128.4"      #(Optional) Set null to get dynamic IP or delete this line
      enable_accelerated_networking = false             #(Optional) 
      enable_ip_forwarding          = true              #(Optional) 
      vm_size                       = "Standard_DS1_v2" #(Mandatory) 
      managed_disk_type             = "Premium_LRS"     #(Mandatory) 
    },
    {
      suffix_name                   = "rdg"             #(Mandatory) suffix of the vm
      id                            = "2"               #(Mandatory) Id of the VM
      os_type                       = "linux"           #(Mandatory) Support "linux" or "windows"
      storage_data_disks            = []                #(Mandatory) For no data disks set []
      internal_lb_iteration         = null              #(Optional) Id of the Internal Load Balancer, set to null if there is no Load Balancer
      public_lb_iteration           = null              #(Optional) Id of the public Load Balancer, set to null if there is no public Load Balancer
      public_ip_iteration           = null              #(Optional) Id of the public Ip, set to null if there is no public Ip
      subnet_iteration              = "1"               #(Mandatory) Id of the Subnet
      zones                         = ["2"]             #(Optional) Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
      security_group_iteration      = null              #(Optional) Id of the Network Security Group, set to null if there is no Network Security Groups
      BackupPolicyName              = null              #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
      static_ip                     = null              #(Optional) Set null to get dynamic IP or delete this line
      enable_accelerated_networking = false             #(Optional) 
      vm_size                       = "Standard_DS1_v2" #(Mandatory) 
      managed_disk_type             = "Premium_LRS"     #(Mandatory) 
      dns_servers                   = ["8.8.8.8"]       #(Optional)
    },
    {
      suffix_name        = "rds"             #(Mandatory) suffix of the vm
      id                 = "1"               #(Mandatory) Id of the VM
      os_type            = "windows"         #(Mandatory) Support "linux" or "windows"
      storage_data_disks = []                #(Mandatory) For no data disks set []
      subnet_iteration   = "1"               #(Mandatory) Id of the Subnet
      zones              = ["1"]             #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
      vm_size            = "Standard_DS1_v2" #(Mandatory) 
      managed_disk_type  = "Premium_LRS"     #(Mandatory) 
    },
  ]
}

variable "default_tags" {
  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Az-VirtualNetwork-Demo" {
  source                      = "github.com/JamesDLD/terraform/module/Az-VirtualNetwork"
  net_prefix                  = "testvm"
  network_resource_group_name = "infr-jdld-noprd-rg2"
  virtual_networks            = var.virtual_networks
  subnets                     = var.subnets
  route_tables                = []
  network_security_groups     = []
  net_tags                    = var.default_tags
}

module "Create-AzureRmLoadBalancer-Demo" {
  source                 = "github.com/JamesDLD/terraform/module/Az-LoadBalancer"
  Lbs                    = var.Lbs
  lb_prefix              = "jdld-sand1-"
  lb_suffix              = "-lb1"
  lb_location            = "westeurope"
  lb_resource_group_name = "infr-jdld-noprd-rg2"
  Lb_sku                 = "basic"
  subnets_ids            = module.Az-VirtualNetwork-Demo.subnet_ids
  lb_tags                = var.default_tags
  LbRules                = []
}

module "Az-Vm-Demo" {
  source                             = "github.com/JamesDLD/terraform/module/Az-Vm"
  sa_bootdiag_storage_uri            = "https://infrsand1vpcjdld1.blob.core.windows.net/" #(Mandatory)
  nsgs_ids                           = ["nsg_id1", "nsg_id2"]
  public_ip_ids                      = ["public_ip_id1", "public_ip_id2"]
  internal_lb_backend_ids            = module.Create-AzureRmLoadBalancer-Demo.lb_backend_ids
  public_lb_backend_ids              = ["public_backend_id1", "public_backend_id1"]
  key_vault_id                       = ""
  rsv_id                             = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""
  subnets_ids                        = module.Az-VirtualNetwork-Demo.subnet_ids
  vms                                = var.vms
  vm_location                        = "westeurope"
  vm_resource_group_name             = "infr-jdld-noprd-rg2"
  vm_prefix                          = "jdld-sand1-"
  admin_username                     = "myadmlogin"
  admin_password                     = "Myadmlogin_StoredInASecretFile?"
  vm_tags                            = var.default_tags
}

```