#Set the terraform backend
terraform {
  required_version = "0.11.13"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-4.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "1.21"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

#Call module/resource
#Get components
module "Get-AzureRmResourceGroup" {
  version = "~> 0.1"
  source  = "github.com/JamesDLD/terraform/module/Get-AzureRmResourceGroup"
  rg_name = "infr-jdld-noprd-rg1"
}

#Action
module "Add-AzureRmLoadBalancerOutboundRules-Apps" {
  version                    = "~> 0.1"
  source                     = "github.com/JamesDLD/terraform/module/Add-AzureRmLoadBalancerOutboundRules"
  lbs_out                    = ["${var.lbs_public}"]
  lb_out_prefix              = "bp4-"
  lb_out_suffix              = "-publiclb1"
  lb_out_resource_group_name = "${module.Get-AzureRmResourceGroup.rg_name}"
  lbs_tags                   = "${module.Get-AzureRmResourceGroup.rg_tags}"
}
