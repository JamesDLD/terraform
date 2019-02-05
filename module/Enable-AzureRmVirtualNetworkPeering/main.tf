#############################################################
##########                  ops                    ##########
#############################################################
data "azurerm_virtual_network" "one_vnets" {
  provider            = "azurerm.provider_one"
  count               = "${length(var.list_one)}"
  name                = "${lookup(var.list_one[count.index], "name")}"
  resource_group_name = "${lookup(var.list_one[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "one_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_one)}"}"
  name                         = "${element(data.azurerm_virtual_network.one_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.one_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "one_dest_to_source" {
  provider                     = "azurerm.provider_one"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_one)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.one_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.one_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########                  sec                    ##########
#############################################################
data "azurerm_virtual_network" "two_vnets" {
  provider            = "azurerm.provider_two"
  count               = "${length(var.list_two)}"
  name                = "${lookup(var.list_two[count.index], "name")}"
  resource_group_name = "${lookup(var.list_two[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "two_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_two)}"}"
  name                         = "${element(data.azurerm_virtual_network.two_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.two_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "two_dest_to_source" {
  provider                     = "azurerm.provider_two"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_two)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.two_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.two_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########                  k8s                    ##########
#############################################################
data "azurerm_virtual_network" "three_vnets" {
  provider            = "azurerm.provider_three"
  count               = "${length(var.list_three)}"
  name                = "${lookup(var.list_three[count.index], "name")}"
  resource_group_name = "${lookup(var.list_three[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "three_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_three)}"}"
  name                         = "${element(data.azurerm_virtual_network.three_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.three_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "three_dest_to_source" {
  provider                     = "azurerm.provider_three"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_three)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.three_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.three_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########               Agile Fabric              ##########
#############################################################
data "azurerm_virtual_network" "four_vnets" {
  provider            = "azurerm.provider_four"
  count               = "${length(var.list_four)}"
  name                = "${lookup(var.list_four[count.index], "name")}"
  resource_group_name = "${lookup(var.list_four[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "four_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_four)}"}"
  name                         = "${element(data.azurerm_virtual_network.four_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.four_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "four_dest_to_source" {
  provider                     = "azurerm.provider_four"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_four)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.four_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.four_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########                   Pub                   ##########
#############################################################
data "azurerm_virtual_network" "five_vnets" {
  provider            = "azurerm.provider_five"
  count               = "${length(var.list_five)}"
  name                = "${lookup(var.list_five[count.index], "name")}"
  resource_group_name = "${lookup(var.list_five[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "five_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_five)}"}"
  name                         = "${element(data.azurerm_virtual_network.five_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.five_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "five_dest_to_source" {
  provider                     = "azurerm.provider_five"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_five)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.five_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.five_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########                List 6                   ##########
#############################################################
data "azurerm_virtual_network" "six_vnets" {
  provider            = "azurerm.provider_six"
  count               = "${length(var.list_six)}"
  name                = "${lookup(var.list_six[count.index], "name")}"
  resource_group_name = "${lookup(var.list_six[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "six_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_six)}"}"
  name                         = "${element(data.azurerm_virtual_network.six_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.six_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "six_dest_to_source" {
  provider                     = "azurerm.provider_six"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_six)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.six_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.six_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########                List  7                  ##########
#############################################################
data "azurerm_virtual_network" "seven_vnets" {
  provider            = "azurerm.provider_seven"
  count               = "${length(var.list_seven)}"
  name                = "${lookup(var.list_seven[count.index], "name")}"
  resource_group_name = "${lookup(var.list_seven[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "seven_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_seven)}"}"
  name                         = "${element(data.azurerm_virtual_network.seven_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.seven_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "seven_dest_to_source" {
  provider                     = "azurerm.provider_seven"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_seven)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.seven_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.seven_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

#############################################################
##########                List  8                  ##########
#############################################################
data "azurerm_virtual_network" "eight_vnets" {
  provider            = "azurerm.provider_eight"
  count               = "${length(var.list_eight)}"
  name                = "${lookup(var.list_eight[count.index], "name")}"
  resource_group_name = "${lookup(var.list_eight[count.index], "resource_group_name")}"
}

resource "azurerm_virtual_network_peering" "eight_source_to_dest" {
  provider                     = "azurerm.src"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_eight)}"}"
  name                         = "${element(data.azurerm_virtual_network.eight_vnets.*.name,count.index)}"
  resource_group_name          = "${var.vnet_rg_src_name}"
  virtual_network_name         = "${var.vnet_src_name}"
  remote_virtual_network_id    = "${element(data.azurerm_virtual_network.eight_vnets.*.id,count.index)}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "eight_dest_to_source" {
  provider                     = "azurerm.provider_eight"
  count                        = "${"${var.Disable_Vnet_Peering}" == "yes" ? "0" : "${var.vnet_src_name}" == "null" ? "0" : "${length(var.list_eight)}"}"
  name                         = "${var.vnet_src_name}"
  resource_group_name          = "${element(data.azurerm_virtual_network.eight_vnets.*.resource_group_name,count.index)}"
  virtual_network_name         = "${element(data.azurerm_virtual_network.eight_vnets.*.name,count.index)}"
  remote_virtual_network_id    = "${var.vnet_src_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
