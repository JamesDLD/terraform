#Set the terraform backend
terraform {
  required_version = ">= 0.12.6"

  backend "azurerm" {
    storage_account_name = "infrsdbx1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-3.0.12.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = ">= 1.31.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Call module/resource
#Get components

data "azurerm_resource_group" "bp3" {
  name = "infr-jdld-noprd-rg1"
}

data "azurerm_storage_account" "bp3" {
  name                = "infrsdbx1vpcjdld1"
  resource_group_name = data.azurerm_resource_group.bp3.name
}

#Action
module "Az-VirtualNetwork-Demo" {
  source                      = "JamesDLD/Az-VirtualNetwork/azurerm"
  version                     = "0.1.1"
  net_prefix                  = "demo"
  network_resource_group_name = data.azurerm_resource_group.bp3.name
  virtual_networks = {
    vnet1 = {
      id            = "1"
      prefix        = "bp3"
      address_space = ["10.0.3.0/24"]
    }
  }
  subnets                 = var.subnets
  route_tables            = {}
  network_security_groups = {}
}

module "Create-AzureRmLoadBalancer-Demo" {
  source                 = "JamesDLD/Az-LoadBalancer/azurerm"
  version                = "0.1.1"
  Lbs                    = var.Lbs
  LbRules                = {}
  lb_prefix              = "demo-bp3"
  lb_location            = element(module.Az-VirtualNetwork-Demo.vnet_locations, 0)
  lb_resource_group_name = data.azurerm_resource_group.bp3.name
  Lb_sku                 = "basic"
  subnets_ids            = module.Az-VirtualNetwork-Demo.subnet_ids
  lb_additional_tags     = { bp = "3" }
}

module "Az-Vm-Demo" {
  source                  = "JamesDLD/Az-Vm/azurerm"
  version                 = "0.1.1"
  sa_bootdiag_storage_uri = data.azurerm_storage_account.bp3.primary_blob_endpoint #(Mandatory)
  subnets_ids             = module.Az-VirtualNetwork-Demo.subnet_ids               #(Mandatory)
  linux_vms               = {}                                                     #(Mandatory)
  windows_vms             = var.vms                                                #(Mandatory)

  #This an implicit dependency
  internal_lb_backend_ids = module.Create-AzureRmLoadBalancer-Demo.lb_backend_ids

  #This an explicit dependency                 
  #internal_lb_backend_ids = ["/subscriptions/${var.subscription_id}/resourceGroups/infr-jdld-noprd-rg1/providers/Microsoft.Network/loadBalancers/demo-bp3-internal-lb1/backendAddressPools/demo-bp3-internal-bckpool1"]

  vm_resource_group_name          = data.azurerm_resource_group.bp3.name
  vm_prefix                       = "bp3"                               #(Optional)
  windows_storage_image_reference = var.windows_storage_image_reference #(Optional)
  admin_username                  = var.app_admin
  admin_password                  = var.pass
  vm_additional_tags              = { bp = "3" } #(Optional)
}
