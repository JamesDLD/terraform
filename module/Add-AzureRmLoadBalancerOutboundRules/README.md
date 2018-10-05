Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

#Set variable
variable "lbs_public" {
  type        = "map"
  description = "Load balancer properties containing those values :suffix_name, sku, allocatedOutboundPorts, idleTimeoutInMinutes, enableTcpReset, protocol"

  default = {
    suffix_name            = "testpublic"
    sku                    = "Standard"
    allocatedOutboundPorts = "1000"       #Number of SNAT ports, Load Balancer allocates SNAT ports in multiples of 8.
    idleTimeoutInMinutes   = "4"          #Outbound flow idle timeout. The parameter accepts a value from 4 to 66.
    enableTcpReset         = "false"      #Enable TCP Reset on idle timeout.
    protocol               = "All"        #Transport protocol of the outbound rule.
  }
}

variable "lb_out_prefix" {
  description = "Prefix used to set a common naming convention on the lb objects."
}

variable "lb_out_suffix" {
  description = "Prefix used to set a common naming convention on the lb objects."
}

variable "lb_out_resource_group_name" {
  description = "Load balancer resource group name."
}

variable "lbs_tags" {
  type = "map"
  description = "Load balancer tags."

  default = {
    ENV = "sand1"
    APP = "JDLD"
    BUD = "FR_BXXXXX"
    CTC = "j.dumont@veebaze.com"
  }
}

#Call module
module "Add-AzureRmLoadBalancerOutboundRules-Apps" {
  source                  = "./module/Add-AzureRmLoadBalancerOutboundRules"
  lbs_out                    = ["${var.lbs_public}"]
  lb_out_prefix              = "myapp-demo-"
  lb_out_suffix              = "-publiclb1"
  lb_out_resource_group_name = "myrg"
  lbs_tags                   = "${var.lbs_tags}"
}
```