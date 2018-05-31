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

variable "rt_name" {
  default = "noprd-default-udr"
}

variable "rt_resource_group_name" {
  default = "apps-jdld-sand1-rg1"
}

#Call module
module "Get-AzureRmRouteTable-Infra" {
  source  = "./module/Get-AzureRmRouteTable"
  rt_name = "${var.rt_name}"
  rt_resource_group_name = "${var.rt_resource_group_name}"
}

```