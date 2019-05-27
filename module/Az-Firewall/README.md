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

variable "fw_resource_group_name" {
  default = "apps-jdld-sand1-rg1"
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

module "Az-Firewall-Infr" {
  source                 = "github.com/JamesDLD/terraform/module/Az-Firewall"
  fw_resource_group_name = var.fw_resource_group_name
  fw_location            = "francecentral"
  fw_prefix              = "demo-fw1"
  fw_subnet_id           = "/xxx/xxxx/subnetid"
  fw_tags                = var.default_tags
}
```