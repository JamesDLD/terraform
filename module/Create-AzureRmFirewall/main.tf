resource "azurerm_public_ip" "pip" {
  name                         = "${var.fw_prefix}-pip1"
  location                     = "${var.fw_location}"
  resource_group_name          = "${var.fw_resource_group_name}"
  public_ip_address_allocation = "Static"
  sku                          = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = "${var.fw_prefix}"
  location            = "${var.fw_location}"
  resource_group_name = "${azurerm_public_ip.pip.resource_group_name}"
  tags                = "${var.fw_tags}"

  ip_configuration {
    name                          = "${var.fw_prefix}-CFG"
    subnet_id                     = "${var.fw_subnet_id}"
    internal_public_ip_address_id = "${azurerm_public_ip.pip.id}"
  }
}

resource "azurerm_firewall_network_rule_collection" "infra_common_services" {
  name                = "infra_common_services-ncol1"
  azure_firewall_name = "${azurerm_firewall.fw.name}"
  resource_group_name = "${azurerm_firewall.fw.resource_group_name}"
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "dns-rule1"
    source_addresses      = ["198.18.0.0/24"]
    destination_ports     = ["53"]
    destination_addresses = ["*"]
    protocols             = ["TCP", "UDP"]
  }

  rule {
    name                  = "rbd-rule1"
    source_addresses      = ["*"]
    destination_ports     = ["3389"]
    destination_addresses = ["198.18.2.230", "198.18.2.231"]
    protocols             = ["TCP"]
  }
}

resource "azurerm_firewall_application_rule_collection" "infra_common_services" {
  name                = "infra_common_services-acol1"
  azure_firewall_name = "${azurerm_firewall.fw.name}"
  resource_group_name = "${azurerm_firewall.fw.resource_group_name}"
  priority            = 100
  action              = "Allow"

  rule {
    name             = "AzureTags-All-rule1"
    source_addresses = ["198.18.0.0/24"]
    fqdn_tags        = ["MicrosoftActiveProtectionService", "WindowsDiagnostics", "WindowsUpdate", "AppServiceEnvironment", "AzureBackup"]
  }

  rule {
    name             = "SecopsFqdn-rule1"
    source_addresses = ["198.18.0.0/24"]
    target_fqdns     = ["google.com", ".windowsupdate.com"]

    protocol {
      port = 443
      type = "Https"
    }

    protocol {
      port = 80
      type = "Http"
    }
  }
}
