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

variable "vnets" {
  default = [
    {
      vnet_suffix_name                   = "demovm1"
      address_spaces                     = "10.0.128.0/24 198.18.2.0/24" #For multiple values add spaces between values
      dns_servers                        = ""                            #For multiple values add spaces between values
      dns_zone_for_the_registration_vnet = "demovm1.jdld.test"           #If you remove this key the zone name will be "vnet_suffix_name.az"
    },
  ]
}

variable "snets" {
  default = [
    {
      name              = "demo1"
      cidr_block        = "10.0.128.0/28"
      nsg_id            = "777"                                                             #Id of the Network Security Group, set to 777 if there is no Network Security Groups
      route_table_id    = "777"                                                             #Id of the Route table, set to 777 if there is no Route table
      vnet_name_id      = "0"                                                               #Id of the vnet
      service_endpoints = "Microsoft.AzureActiveDirectory Microsoft.KeyVault Microsoft.Sql" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
    },
    {
      name              = "demo2"
      cidr_block        = "10.0.128.16/28"
      nsg_id            = "777" #Id of the Network Security Group, set to 777 if there is no Network Security Groups
      route_table_id    = "777" #Id of the Route table, set to 777 if there is no Route table
      vnet_name_id      = "0"   #Id of the vnet
      service_endpoints = ""    #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
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
  source                   = "../../Az-VirtualNetwork"
  vnets                    = var.vnets
  vnet_prefix              = "infra-demo-"
  vnet_suffix              = "-net1"
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
  vnet_location            = "francecentral"
  vnet_tags                = var.default_tags
}

module "Az-Subnet-Demo" {
  source                     = "../../Az-Subnet"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = "infr-jdld-noprd-rg1"
  snet_list                  = var.snets
  vnet_names                 = module.Az-VirtualNetwork-Demo.vnet_names
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]
}

module "Create-AzureRmLoadBalancer-Demo" {
  source                 = "../../Az-LoadBalancer"
  Lbs                    = var.Lbs
  lb_prefix              = "jdld-sand1-"
  lb_suffix              = "-lb1"
  lb_location            = "francecentral"
  lb_resource_group_name = "infr-jdld-noprd-rg1"
  Lb_sku                 = "basic"
  subnets_ids            = module.Az-Subnet-Demo.subnets_ids
  lb_tags                = var.default_tags
  LbRules                = []
}

module "Az-Vm-Demo" {
  source                             = "../../Az-Vm"
  sa_bootdiag_storage_uri            = "https://infrsand1vpcjdld1.blob.core.windows.net/" #(Mandatory)
  nsgs_ids                           = ["nsg_id1", "nsg_id2"]
  public_ip_ids                      = ["public_ip_id1", "public_ip_id2"]
  internal_lb_backend_ids            = module.Create-AzureRmLoadBalancer-Demo.lb_backend_ids
  public_lb_backend_ids              = ["public_backend_id1", "public_backend_id1"]
  key_vault_id                       = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""
  subnets_ids                        = module.Az-Subnet-Demo.subnets_ids
  vms                                = var.vms
  vm_location                        = "francecentral"
  vm_resource_group_name             = "infr-jdld-noprd-rg1"
  vm_prefix                          = "jdld-sand1-"
  admin_username                     = "myadmlogin"
  admin_password                     = "Myadmlogin_StoredInASecretFile?"
  vm_tags                            = var.default_tags
}
```