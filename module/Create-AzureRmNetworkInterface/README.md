Usage
-----

#Set the Provider
provider "azurerm" {
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "Linux_Vms" {
  type = "map"

  default = {
    suffix_name       = "ssh"
    id                = "1"                      #Id of the VM
    Id_Lb             = "777"                    #Id of the Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "777"                    #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "198.18.1.228"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "redhat"
    offer             = "RHEL"
    sku               = "7.3"
    lun               = "0"
    disk_size_gb      = "32"
  }
}

variable "nic_location" {
  default = "northeurope"
}

variable "nic_resource_group_name" {
  default = "apps-jdld-sand1-rg1"
}

variable "subnets_ids" {
  type    = "list"
  default = ["/subscriptions/xxx-subscription_id-xxx/resourceGroups/apps-jdld-sand1-rg1/providers/Microsoft.Network/virtualNetworks/myvnet/subnets/mysubnet"]
}

variable "lb_backend_ids" {
  type    = "list"
  default = ["/subscriptions/xxx-subscription_id-xxx/resourceGroups/apps-jdld-sand1-rg1/providers/Microsoft.Network/loadBalancers/lbname/backendAddressPools/bckpoolname"]
}

variable "nic_tags" {
  type = "map"

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

variable "nsgs_ids" {
  type    = "list"
  default = ["/subscriptions/xxx-subscription_id-xxx/resourceGroups/apps-jdld-sand1-rg1/providers/Microsoft.Network/networkSecurityGroups/nsgname"]
}

#Call module
module "Create-AzureRmNetworkInterface-Apps" {
  source                  = "./module/Create-AzureRmNetworkInterface"
  Linux_Vms               = ["${var.Linux_Vms}"]                      #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = []                                        #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "jdld-sand1-"
  nic_suffix              = "-nic1"
  nic_location            = "${var.nic_location}"
  nic_resource_group_name = "${var.nic_resource_group_name}"
  subnets_ids             = "${var.subnets_ids}"
  lb_backend_ids          = "${var.lb_backend_ids}"
  nic_tags                = "${var.nic_tags}"
  nsgs_ids                = "${var.nsgs_ids}"
}
