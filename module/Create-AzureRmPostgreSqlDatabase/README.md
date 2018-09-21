Usage
---

```hcl
#Set the Provider
provider "azurerm" {
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "postgresql_server"{
  type = "map"
  
  default = {
    suffix_name            = "demopg"
    administrator_login    = "psqladminun"
    administrator_password = "H@Sh1CoR3!"
    version                = "9.5"
    ssl_enforcement        = "Enabled"
    sku_name               = "B_Gen4_2"
    sku_capacity           = 2
    sku_tier               = "Basic"
    sku_family             = "Gen4"
    config_value           = "on"
    storage_mb             = 5120
    backup_retention_days  = 7
    geo_redundant_backup   = "Disabled"
  }
}

variable "pgsql_config" {
  type = "map"
  
  default = {
    id_server = "0"  #Must match an Id of one postgresql_server
    value     = "on"
  }
}

variable "pgsql_db_firewall" {
  type = "map"
  
  default = {
    id_server = "0" #Must match an Id of one postgresql_server
    id        = "1" #Id of the postgre sql database
    start_ip  = "192.168.1.10"
    end_ip    = "192.168.1.19"
  }
}

variable "pgsql_db" {
  type = "map"
  
  default = {
    id_server   = "0"                          #Must match an Id of one postgresql_server
    id          = "1"                          #Id of the postgre sql database
    suffix_name = "demopg"
    charset     = "UTF8"
    collation   = "English_United States.1252"
  }
}

variable "pgsql_location" {
  default = "northeurope"
}

variable "pgsql_rg" {
  default = "MyRg"
}

module "Create-AzureRmPostgreSqlDatabase-Apps" {
  source                    = "./module/Create-AzureRmPostgreSqlDatabase"
  pgsql_prefix              = "myapp"
  pgsql_suffix              = "-pgsql1"
  pgsql_server              = ["${var.pgsql_server}"]
  pgsql_administrator_login    = "admindemo"
  pgsql_administrator_password = "Password123"
  pgsql_config              = ["${var.pgsql_config}"]
  pgsql_db_firewall         = ["${var.pgsql_db_firewall}"]
  pgsql_db                  = ["${var.pgsql_db}"]
  pgsql_resource_group_name = "MyRgName"
  pgsql_location            = "northeurope"
  pgsql_subnet_id           = "/subscriptions/xxxxxxxxx/resourceGroups/MyRgName/providers/Microsoft.Network/virtualNetworks/MyVnetName/subnets/MySubnetName""
}

```