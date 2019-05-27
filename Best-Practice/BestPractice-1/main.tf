#Set the terraform backend
terraform {
  backend "azurerm" {
    storage_account_name = "infrsand1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-1.0.12.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Call module/resource
resource "azurerm_virtual_network" "bp1-vnet1" {
  name                = "bp1-vnet1"
  location            = "francecentral"
  resource_group_name = "infr-jdld-noprd-rg1"
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "bp1-front-snet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    environment = "Test"
  }
}

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "test" {
}

resource "azurerm_role_assignment" "test" {
  scope                = azurerm_virtual_network.bp1-vnet1.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_client_config.test.service_principal_object_id
}

output "subnet_ids" {
  description = "The subnet Ids."
  value = azurerm_virtual_network.bp1-vnet1.subnet.*.id
}