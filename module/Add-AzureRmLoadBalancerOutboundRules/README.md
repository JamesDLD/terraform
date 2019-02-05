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
  source                     = "github.com/JamesDLD/terraform/module/Add-AzureRmLoadBalancerOutboundRules"
  version 				           = "94729e4"
  lbs_out                    = ["${var.lbs_public}"]
  lb_out_prefix              = "myapp-demo-"
  lb_out_suffix              = "-publiclb1"
  lb_out_resource_group_name = "myrg"
  lbs_tags                   = ["${var.lbs_tags}"]

  #Optional : you can use an existing public ip, otherwise it will create one 
  lb_public_ip_id = "/subscriptions/mysubid/resourceGroups/tenant-testi-prd-rg/providers/Microsoft.Network/publicIPAddresses/scinfra-testi-prd-pip-0"
}
```