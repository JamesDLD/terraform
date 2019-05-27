#Set the terraform backend
terraform {
  required_version = "0.12.0"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-4.0.12.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "1.27.1"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Call module/resource
data "azurerm_resource_group" "infr" {
  name = "infr-jdld-noprd-rg1"
}

#Action
module "Add-AzureRmLoadBalancerOutboundRules-Apps" {
  source                     = "git::https://github.com/JamesDLD/terraform.git//module/Add-AzureRmLoadBalancerOutboundRules?ref=feature/terraform0.12"
  lbs_out                    = var.lbs_public
  lb_out_prefix              = "bp4-"
  lb_out_suffix              = "-publiclb1"
  lb_out_resource_group_name = data.azurerm_resource_group.infr.name
  lbs_tags                   = data.azurerm_resource_group.infr.tags
}

