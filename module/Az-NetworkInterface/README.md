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

variable "Linux_Vms" {
  default = [
    {
      suffix_name                   = "ssh"
      id                            = "1"                      #Id of the VM
      Id_Lb                         = "777"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
      Id_Lb_Public                  = "777"                    #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
      Id_Ip_Public                  = "777"                    #Id of the public Ip, set to 777 if there is no public Ip
      Id_Subnet                     = "0"                      #Id of the Subnet
      zone                          = "1"                      #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
      Id_Nsg                        = "777"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
      BackupPolicyName              = "BackupPolicy-Schedule1" #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
      static_ip                     = "10.0.1.6"          #Set 777 to get dynamic IP
      enable_accelerated_networking = "false"
      vm_size                       = "Standard_DS1_v2"
      managed_disk_type             = "Premium_LRS"
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
module "Az-NetworkInterface-Demo" {
  source                 = "github.com/JamesDLD/terraform/module/Az-NetworkInterface"
  subscription_id         = var.subscription_id
  Linux_Vms               = var.Linux_Vms                      #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = []                                        #If no need just fill "Windows_Vms = []" in the tfvars file
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
```