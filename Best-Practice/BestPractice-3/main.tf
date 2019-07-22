#Set the terraform backend
terraform {
  required_version = "0.12.3"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-3.0.12.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "1.31.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Call module/resource
#Get components
module "Get-AzureRmVirtualNetwork" {
  source                   = "git::https://github.com/JamesDLD/terraform.git//module/Get-AzureRmVirtualNetwork?ref=master"
  vnets                    = ["bp1-vnet1"]
  vnet_resource_group_name = "infr-jdld-noprd-rg1"
}

data "azurerm_resource_group" "infr" {
  name = "infr-jdld-noprd-rg1"
}

data "azurerm_storage_account" "infr" {
  name                = "infrsand1vpcjdld1"
  resource_group_name = data.azurerm_resource_group.infr.name
}

#Action
module "Az-Subnet-Demo" {
  source                     = "git::https://github.com/JamesDLD/terraform.git//module/Az-Subnet?ref=master"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = data.azurerm_resource_group.infr.name
  snet_list                  = var.subnets
  vnet_names                 = module.Get-AzureRmVirtualNetwork.vnet_names
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]
}

module "Az-LoadBalancer-Demo" {
  source                 = "git::https://github.com/JamesDLD/terraform.git//module/Az-LoadBalancer?ref=master"
  Lbs                    = var.Lbs
  lb_prefix              = "bp3-"
  lb_suffix              = "-lb1"
  lb_location            = data.azurerm_resource_group.infr.location
  lb_resource_group_name = data.azurerm_resource_group.infr.name
  Lb_sku                 = "Standard"
  subnets_ids            = module.Az-Subnet-Demo.subnets_ids
  lb_tags                = data.azurerm_resource_group.infr.tags
  LbRules                = []
}

module "Az-Vm-Demo" {
  source                             = "git::https://github.com/JamesDLD/terraform.git//module/Az-Vm?ref=feature/nomoreusingnull_resource"
  sa_bootdiag_storage_uri            = data.azurerm_storage_account.infr.primary_blob_endpoint
  nsgs_ids                           = [""]
  public_ip_ids                      = ["null"]
  internal_lb_backend_ids            = module.Az-LoadBalancer-Demo.lb_backend_ids
  public_lb_backend_ids              = ["null"]
  key_vault_id                       = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""
  subnets_ids                        = module.Az-Subnet-Demo.subnets_ids
  vms                                = var.vms
  windows_storage_image_reference    = var.windows_storage_image_reference #If no need just fill "windows_storage_image_reference = []" in the tfvars file
  vm_location                        = data.azurerm_resource_group.infr.location
  vm_resource_group_name             = data.azurerm_resource_group.infr.name
  vm_prefix                          = "bp3-"
  vm_tags                            = data.azurerm_resource_group.infr.tags
  admin_username                     = var.app_admin
  admin_password                     = var.pass
}

