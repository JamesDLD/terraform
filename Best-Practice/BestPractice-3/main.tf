#Set the terraform backend
terraform {
  required_version = "0.12.0"

  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-3.0.12.tfstate"
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
#Get components
module "Get-AzureRmVirtualNetwork" {
  source                   = "github.com/JamesDLD/terraform/module/Get-AzureRmVirtualNetwork"
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
  source                     = "github.com/JamesDLD/terraform/module/Az-Subnet"
  subscription_id            = var.subscription_id
  subnet_resource_group_name = data.azurerm_resource_group.infr.name
  snet_list                  = [var.subnets]
  vnet_names                 = module.Get-AzureRmVirtualNetwork.vnet_names
  nsgs_ids                   = ["null"]
  route_table_ids            = ["null"]
}

module "Az-LoadBalancer-Demo" {
  source                 = "github.com/JamesDLD/terraform/module/Az-LoadBalancer"
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

module "Az-NetworkInterface-Demo" {
  source                  = "github.com/JamesDLD/terraform/module/Az-NetworkInterface"
  subscription_id         = var.subscription_id
  Linux_Vms               = []                #If no need just fill "Linux_Vms = []" in the tfvars file
  Windows_Vms             = var.Windows_Vms #If no need just fill "Windows_Vms = []" in the tfvars file
  nic_prefix              = "bp3-"
  nic_suffix              = "-nic1"
  nic_location            = data.azurerm_resource_group.infr.location
  nic_resource_group_name = data.azurerm_resource_group.infr.name
  subnets_ids             = module.Az-Subnet-Demo.subnets_ids
  lb_backend_ids          = module.Az-LoadBalancer-Demo.lb_backend_ids
  lb_backend_Public_ids   = ["null"]
  nic_tags                = data.azurerm_resource_group.infr.tags
  nsgs_ids                = [""]
}

module "Az-Vm-Demo" {
  source                             = "github.com/JamesDLD/terraform/module/Az-Vm"
  subscription_id                    = var.subscription_id
  sa_bootdiag_storage_uri            = data.azurerm_storage_account.infr.primary_blob_endpoint
  key_vault_id                       = ""
  disable_log_analytics_dependencies = "true"
  workspace_resource_group_name      = ""
  workspace_name                     = ""

  Linux_Vms                     = [] #If no need just fill "Linux_Vms = []" in the tfvars file
  Linux_nics_ids                = []
  Linux_storage_image_reference = []
  Linux_DataDisks               = []
  ssh_key                       = ""

  Windows_Vms                     = var.Windows_Vms #If no need just fill "Windows_Vms = []" in the tfvars file
  Windows_nics_ids                = module.Az-NetworkInterface-Demo.Windows_nics_ids
  Windows_storage_image_reference = var.Windows_storage_image_reference #If no need just fill "Windows_storage_image_reference = []" in the tfvars file
  Windows_DataDisks               = []

  vm_location            = data.azurerm_resource_group.infr.location
  vm_resource_group_name = data.azurerm_resource_group.infr.name
  vm_prefix              = "bp3-"
  vm_tags                = data.azurerm_resource_group.infr.tags
  app_admin              = var.app_admin
  pass                   = var.pass
}

