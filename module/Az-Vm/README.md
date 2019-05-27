Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
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

variable "Windows_Vms" {
  default = [
  {
    suffix_name                   = "rdg"
    id                            = "1"               #Id of the VM
    Id_Lb                         = "777"             #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777"             #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777"             #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "0"               #Id of the Subnet
    zone                          = "1"               #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "777"               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "777"             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "10.0.1.10"       #Set 777 to get dynamic IP
    enable_accelerated_networking = "false"
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
  },
  {
    suffix_name                   = "rdg"
    id                            = "2"               #Id of the VM
    Id_Lb                         = "777"             #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777"             #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777"             #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "0"               #Id of the Subnet
    zone                          = "2"               #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "777"               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "777"             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "777"             #Set 777 to get dynamic IP
    enable_accelerated_networking = "false"
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
  },
  ]
}

variable "Windows_DataDisks" {
  default = [
  {
    id                = "0"           #Id of the VM from the upper list
    suffix_name       = "rdg1"        #MUST match the VM suffix_name + the id of the VM
    id_disk           = "1"           #Id of the disk
    zone              = "1"           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to ""
    managed_disk_type = "Premium_LRS"
    lun               = "0"
    disk_size_gb      = "32"
    caching           = "ReadWrite"
  },
  ]
}
variable "Windows_storage_image_reference" {
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "Latest"
  }
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
module "Az-NetworkInterface-Demo" {
  source                 = "github.com/JamesDLD/terraform/module/Az-NetworkInterface"
  subscription_id         = var.subscription_id
  Linux_Vms               = []                      #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = var.Windows_Vms          #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "jdld-sand1-"
  nic_suffix              = "-nic1"
  nic_location            = "francecentral"
  nic_resource_group_name = "infr-jdld-noprd-rg1"
  subnets_ids            = ["/subscriptions/${var.subscription_id}/resourceGroups/infr-jdld-noprd-rg1/providers/Microsoft.Network/virtualNetworks/bp1-vnet1/subnets/bp1-front-snet1",
                            "/subscriptions/${var.subscription_id}/resourceGroups/infr-jdld-noprd-rg1/providers/Microsoft.Network/virtualNetworks/bp1-vnet1/subnets/bp1-front-snet2"]
  lb_backend_ids          = ["internal_backend_id1","internal_backend_id1"]
  lb_backend_Public_ids   = ["public_backend_id1","public_backend_id1"]
  nic_tags                = var.default_tags
  nsgs_ids                = ["nsg_id1","nsg_id2"]
}
module "Az-Vm-Demo" {
  source = "github.com/JamesDLD/terraform/module/Az-Vm"
  subscription_id                    = var.subscription_id
  sa_bootdiag_storage_uri            = "https://infrsand1vpcjdld1.blob.core.windows.net/"
  key_vault_id                       = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""

  Linux_Vms                     = [] #If no need just fill "Linux_Vms = []" in the tfvars file
  Linux_nics_ids                = []
  Linux_storage_image_reference = null
  Linux_DataDisks               = []
  ssh_key                       = null

  Windows_Vms                     = var.Windows_Vms #If no need just fill "Windows_Vms = []" in the tfvars file
  Windows_nics_ids                = module.Az-NetworkInterface-Demo.Windows_nics_ids
  Windows_storage_image_reference = var.Windows_storage_image_reference 
  Windows_DataDisks               = var.Windows_DataDisks

  vm_location            = "francecentral"
  vm_resource_group_name = "infr-jdld-noprd-rg1"
  vm_prefix              = "jdld-sand1-"
  vm_tags                = var.default_tags
  app_admin              = "myadmlogin"
  pass                   = "Myadmlogin_StoredInASecretFile?"
}

```