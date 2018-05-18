Usage
-----

```hcl
#Set the Provider
provider "azurerm" {
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "Lbs" {
  type = "map"

  default = {
    suffix_name = "bou"       #It must equals the Vm suffix_name
    Id_Subnet   = "0"         #Id of the Subnet
    static_ip   = "10.0.3.13"
  }
}

variable "app_name" {
  default = "jdld"
}

variable "env_name" {
  default = "sand1"
}

variable "location" {
  default = "northeurope"
}

variable "rg_apps_name" {
  default = "apps-jdld-sand1-rg1"
}

variable "Lb_sku" {
  default = "Standard"
}

variable "subnets_ids" {
  default = ["/subscriptions/XXXXXXXXXXXXXXXXXXXXXXXXXXX/resourceGroups/infr-jdld-noprd-rg1/providers/Microsoft.Network/virtualNetworks/apps-jdld-sand1-net1/subnets/jdld-sand1-rebond-snet1"]
}

variable "LbRules" {
  type = "map"

  default = {
    Id             = "1"    #Id of a the rule within the Load Balancer 
    Id_Lb          = "0"    #Id of the Load Balancer
    suffix_name    = "bou"  #It must equals the Lbs suffix_name
    lb_port        = "80"
    probe_protocol = "Http"
    request_path   = "/"
  }
}

variable "default_tags" {
  type = "map"

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "./module/Create-AzureRmLoadBalancer"
  Lbs                    = ["${var.Lbs}"]
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = "${var.location}"
  lb_resource_group_name = "${var.rg_apps_name}"
  Lb_sku                 = "${var.Lb_sku}"
  subnets_ids            = "${var.subnets_ids}"
  lb_tags                = "${var.default_tags}"
  LbRules                = ["${var.LbRules}"]
}
```