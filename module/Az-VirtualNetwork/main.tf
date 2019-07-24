

# -
# - Terraform's modules : rules of the game --> https://www.terraform.io/docs/modules/index.html
# -

# -
# - Data gathering
# -
data "azurerm_resource_group" "network" {
  name = var.network_resource_group_name
}

locals {
  location = var.net_location == "" ? data.azurerm_resource_group.network.location : var.net_location
  tags     = var.net_tags == {} ? data.azurerm_resource_group.network.tags : var.net_tags
}

/*
#Data source feature request in progress : https://github.com/terraform-providers/terraform-provider-azurerm/issues/3851
data "azurerm_network_ddos_protection_plan" "one" {
  name                = var.network_ddos_protection_plan["name"]
  resource_group_name = var.network_ddos_protection_plan["resource_group_name"]
}
*/

# -
# - Network
# -

resource "azurerm_virtual_network" "vnets" {
  count               = length(var.virtual_networks)
  name                = "${var.net_prefix}${var.virtual_networks[count.index]["prefix"]}-${local.location}-vnet${var.virtual_networks[count.index]["id"]}"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.network.name
  address_space       = var.virtual_networks[count.index]["address_space"]

  dynamic "ddos_protection_plan" {
    for_each = var.network_ddos_protection_plan
    content {
      id     = lookup(ddos_protection_plan.value, "id", null)
      enable = lookup(ddos_protection_plan.value, "enable", false)
    }
  }

  tags = local.tags
}

# -
# - Subnet
# -

resource "azurerm_subnet" "subnets" {
  count                     = length(var.subnets)
  name                      = var.subnets[count.index]["name"]
  resource_group_name       = data.azurerm_resource_group.network.name
  virtual_network_name      = element(azurerm_virtual_network.vnets.*.name, var.subnets[count.index]["virtual_network_iteration"])
  address_prefix            = var.subnets[count.index]["address_prefix"]
  service_endpoints         = lookup(var.subnets[count.index], "service_endpoints", null)
  route_table_id            = lookup(var.subnets[count.index], "route_table_iteration", null) == null ? null : element(azurerm_route_table.rts.*.id, var.subnets[count.index]["route_table_iteration"])
  network_security_group_id = lookup(var.subnets[count.index], "security_group_iteration", null) == null ? null : element(azurerm_network_security_group.nsgs.*.id, var.subnets[count.index]["security_group_iteration"])
}

# -
# - Route Table
# -

resource "azurerm_route_table" "rts" {
  count                         = length(var.route_tables)
  name                          = "${var.net_prefix}-${local.location}-rt${var.route_tables[count.index]["id"]}"
  location                      = local.location
  resource_group_name           = data.azurerm_resource_group.network.name
  disable_bgp_route_propagation = lookup(var.route_tables[count.index], "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = lookup(var.route_tables[count.index], "routes", null)
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }
  tags = local.tags
}

locals {
  subnets_with_route_table = [for x in var.subnets : x if lookup(x, "route_table_iteration", "null") != "null"]
}

resource "azurerm_subnet_route_table_association" "route_table_associations" {
  count          = length(local.subnets_with_route_table)
  subnet_id      = [for x in azurerm_subnet.subnets : x.id if x.name == local.subnets_with_route_table[count.index]["name"]][0]
  route_table_id = element(azurerm_route_table.rts.*.id, local.subnets_with_route_table[count.index]["route_table_iteration"])
}

# -
# - Network Security Group
# -

resource "azurerm_network_security_group" "nsgs" {
  count               = length(var.network_security_groups)
  name                = "${var.net_prefix}-${local.location}-nsg${var.network_security_groups[count.index]["id"]}"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.network.name

  dynamic "security_rule" {
    for_each = var.network_security_groups[count.index]["security_rules"]
    content {
      description                  = lookup(security_rule.value, "description", null)
      direction                    = lookup(security_rule.value, "direction", null)
      name                         = lookup(security_rule.value, "name", null)
      access                       = lookup(security_rule.value, "access", null)
      priority                     = lookup(security_rule.value, "priority", null)
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", null)
      destination_port_range       = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", null)
      protocol                     = lookup(security_rule.value, "protocol", null)
      source_port_range            = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", null)
    }
  }
  tags = local.tags
}

locals {
  subnets_with_network_security_group = [for x in var.subnets : x if lookup(x, "security_group_iteration", "null") != "null"]
}

resource "azurerm_subnet_network_security_group_association" "security_group_associations" {
  count                     = length(local.subnets_with_network_security_group)
  subnet_id                 = [for x in azurerm_subnet.subnets : x.id if x.name == local.subnets_with_network_security_group[count.index]["name"]][0]
  network_security_group_id = element(azurerm_network_security_group.nsgs.*.id, local.subnets_with_network_security_group[count.index]["security_group_iteration"])
}

# -
# - Bastion
# -

locals {
  vnets_with_bastion     = [for x in var.virtual_networks : x if x.bastion == true]
  vnets_with_out_bastion = [for x in var.virtual_networks : x if x.bastion == false]
}

#Using a template because the resource is not ready, feature request done here : https://github.com/terraform-providers/terraform-provider-azurerm/issues/3829
resource "azurerm_template_deployment" "bastion" {
  depends_on          = [azurerm_virtual_network.vnets]
  count               = length(local.vnets_with_bastion)
  name                = "${var.net_prefix}-${local.location}-vnet${local.vnets_with_bastion[count.index]["id"]}-bas1-dep"
  resource_group_name = data.azurerm_resource_group.network.name
  template_body = file(
    "${path.module}/AzureRmBastion_template.json",
  )
  deployment_mode = "Incremental"

  parameters = {
    location            = local.location
    resourceGroupName   = data.azurerm_resource_group.network.name
    bastionHostName     = "${var.net_prefix}-${local.location}-vnet${local.vnets_with_bastion[count.index]["id"]}-bas1"
    subnetName          = "AzureBastionSubnet"
    publicIpAddressName = "${var.net_prefix}-${local.location}-vnet${local.vnets_with_bastion[count.index]["id"]}-bas1-pip1"
    existingVNETName    = "${var.net_prefix}-${local.location}-vnet${local.vnets_with_bastion[count.index]["id"]}"
    subnetAddressPrefix = [for x in local.vnets_with_bastion[count.index]["subnets"] : x.address_prefix if x.name == "AzureBastionSubnet"][0]
    tags                = jsonencode(local.location)
  }
}
