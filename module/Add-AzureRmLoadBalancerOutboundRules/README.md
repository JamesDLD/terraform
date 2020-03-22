Usage
-----
```hcl
#Set the Provider
provider "azurerm" {
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  version         = "~> 2.0"
  features {}
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

variable "lbs_public" {
  default = [
    {
      suffix_name            = "testpublic"
      sku                    = "Standard"
      allocatedOutboundPorts = "1000"       #Number of SNAT ports, Load Balancer allocates SNAT ports in multiples of 8.
      idleTimeoutInMinutes   = "4"          #Outbound flow idle timeout. The parameter accepts a value from 4 to 66.
      enableTcpReset         = "false"      #Enable TCP Reset on idle timeout.
      protocol               = "All"        #Transport protocol of the outbound rule.
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
module "Add-AzureRmLoadBalancerOutboundRules-Demo" {
  source                 = "github.com/JamesDLD/terraform/module/Add-AzureRmLoadBalancerOutboundRules"
  lbs_out                    = var.lbs_public
  lb_out_prefix              = "myapp-demo-"
  lb_out_suffix              = "-publiclb1"
  lb_out_resource_group_name = "infr-jdld-noprd-rg1"
  lbs_tags                   = var.default_tags
  #Optional : you can use an existing public ip, otherwise it will create one 
  #lb_public_ip_id = "/subscriptions/mysubid/resourceGroups/tenant-testi-prd-rg/providers/Microsoft.Network/publicIPAddresses/scinfra-testi-prd-pip-0"
}

```