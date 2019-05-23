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
variable "subnets_ids" {
  default = ["/subscriptions/xxxxxxxxxxxxxxxxxxx/resourceGroups/infr-jdld-noprd-rg1/providers/Microsoft.Network/virtualNetworks/bp1-vnet1/subnets/bp1-front-snet1"]
}

variable "Lbs" {
  default = [
    {
      suffix_name = "bou" #It must equals the Vm suffix_name
      Id_Subnet   = "0"   #Id of the Subnet
      static_ip   = "10.0.1.4"
    },
    {
      suffix_name = "bas" #It must equals the Vm suffix_name
      Id_Subnet   = "0"   #Id of the Subnet
      static_ip   = "10.0.1.5"
    },
  ]
}

variable "app_name" {
  default = "jdld"
}

variable "env_name" {
  default = "sand1"
}

variable "location" {
  default = "francecentral"
}

variable "rg_apps_name" {
  default = "infr-jdld-noprd-rg1"
}

variable "Lb_sku" {
  default = "Standard"
}

variable "LbRules" {
  default = [
    {
      Id             = "1"   #Id of a the rule within the Load Balancer 
      Id_Lb          = "0"   #Id of the Load Balancer
      suffix_name    = "bou" #It must equals the Lbs suffix_name
      lb_port        = "80"
      probe_port     = "80"
      backend_port    ="80"
      probe_protocol = "Http"
      request_path   = "/"
      load_distribution = "SourceIPProtocol"
    },
  ]
}

variable "default_tags" {
  type = map(string)

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Create-AzureRmLoadBalancer-Apps" {
  source                 = "github.com/JamesDLD/terraform/module/Az-LoadBalancer"
  Lbs                    = var.Lbs
  lb_prefix              = "${var.app_name}-${var.env_name}-"
  lb_suffix              = "-lb1"
  lb_location            = var.location
  lb_resource_group_name = var.rg_apps_name
  Lb_sku                 = var.Lb_sku
  subnets_ids            = var.subnets_ids
  lb_tags                = var.default_tags
  LbRules                = var.LbRules
}

```