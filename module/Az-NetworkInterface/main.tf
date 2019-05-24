#Linux
resource "null_resource" "linux_vms_nics" {
  count = length(var.Linux_Vms)

  triggers = {
    InternalLb-Linux_nic_name = var.Linux_Vms[count.index]["Id_Lb"] == 777 ? "" : "${var.nic_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}${var.nic_suffix}"
    InternalLb-Linux_id_lb    = var.Linux_Vms[count.index]["Id_Lb"] == 777 ? "" : var.Linux_Vms[count.index]["Id_Lb"]
    PublicLb-Linux_nic_name   = var.Linux_Vms[count.index]["Id_Lb_Public"] == 777 ? "" : "${var.nic_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}${var.nic_suffix}"
    PublicLb-Linux_id_lb      = var.Linux_Vms[count.index]["Id_Lb_Public"] == 777 ? "" : var.Linux_Vms[count.index]["Id_Lb_Public"]
  }
}

locals {
  InternalLb-Linux_nic_names = compact(
    null_resource.linux_vms_nics.*.triggers.InternalLb-Linux_nic_name,
  )
  InternalLb-Linux_id_lbs = compact(
    null_resource.linux_vms_nics.*.triggers.InternalLb-Linux_id_lb,
  )
  PublicLb-Linux_nic_names = compact(
    null_resource.linux_vms_nics.*.triggers.PublicLb-Linux_nic_name,
  )
  PublicLb-Linux_id_lbs = compact(null_resource.linux_vms_nics.*.triggers.PublicLb-Linux_id_lb)
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_vms_nics_Internal_Backend_ids" {
  depends_on            = [azurerm_network_interface.linux_vms_nics]
  count                 = length(local.InternalLb-Linux_nic_names)
  network_interface_id  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.InternalLb-Linux_nic_names, count.index)}"
  ip_configuration_name = "${element(local.InternalLb-Linux_nic_names, count.index)}-CFG----${local.InternalLb-Linux_nic_names[0]}"
  backend_address_pool_id = element(
    var.lb_backend_ids,
    element(local.InternalLb-Linux_id_lbs, count.index),
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_vms_nics_Public_Backend_ids" {
  depends_on            = [azurerm_network_interface.linux_vms_nics]
  count                 = length(local.PublicLb-Linux_nic_names)
  network_interface_id  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.PublicLb-Linux_nic_names, count.index)}"
  ip_configuration_name = "${element(local.PublicLb-Linux_nic_names, count.index)}-CFG"
  backend_address_pool_id = element(
    var.lb_backend_Public_ids,
    element(local.InternalLb-Linux_id_lbs, count.index),
  )
}

resource "azurerm_network_interface" "linux_vms_nics" {
  count                         = length(var.Linux_Vms)
  name                          = "${var.nic_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}${var.nic_suffix}"
  location                      = var.nic_location
  resource_group_name           = var.nic_resource_group_name
  network_security_group_id     = var.Linux_Vms[count.index]["Id_Nsg"] == 777 ? "" : element(var.nsgs_ids, var.Linux_Vms[count.index]["Id_Nsg"])
  enable_accelerated_networking = var.Linux_Vms[count.index]["enable_accelerated_networking"]

  ip_configuration {
    name = "${var.nic_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}${var.nic_suffix}-CFG"

    subnet_id                     = element(var.subnets_ids, var.Linux_Vms[count.index]["Id_Subnet"])
    private_ip_address_allocation = var.Linux_Vms[count.index]["static_ip"] == 777 ? "dynamic" : "static"
    private_ip_address            = var.Linux_Vms[count.index]["static_ip"] == 777 ? "" : var.Linux_Vms[count.index]["static_ip"]
    public_ip_address_id          = var.Linux_Vms[count.index]["Id_Ip_Public"] == 777 ? "" : var.Linux_Vms[count.index]["Id_Ip_Public"]
  }

  tags = var.nic_tags
}

#Windows
resource "null_resource" "windows_vms_nics" {
  count = length(var.Windows_Vms)

  triggers = {
    InternalLb-Windows_nic_name = var.Windows_Vms[count.index]["Id_Lb"] == 777 ? "" : "${var.nic_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}${var.nic_suffix}"
    InternalLb-Windows_id_lb    = var.Windows_Vms[count.index]["Id_Lb"] == 777 ? "" : var.Windows_Vms[count.index]["Id_Lb"]
    PublicLb-Windows_nic_name   = var.Windows_Vms[count.index]["Id_Lb_Public"] == 777 ? "" : "${var.nic_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}${var.nic_suffix}"
    PublicLb-Windows_id_lb      = var.Windows_Vms[count.index]["Id_Lb_Public"] == 777 ? "" : var.Windows_Vms[count.index]["Id_Lb_Public"]
  }
}

locals {
  InternalLb-Windows_nic_names = compact(
    null_resource.windows_vms_nics.*.triggers.InternalLb-Windows_nic_name,
  )
  InternalLb-Windows_id_lbs = compact(
    null_resource.windows_vms_nics.*.triggers.InternalLb-Windows_id_lb,
  )
  PublicLb-Windows_nic_names = compact(
    null_resource.windows_vms_nics.*.triggers.PublicLb-Windows_nic_name,
  )
  PublicLb-Windows_id_lbs = compact(
    null_resource.windows_vms_nics.*.triggers.PublicLb-Windows_id_lb,
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_vms_nics_Internal_Backend_ids" {
  depends_on            = [azurerm_network_interface.Windows_Vms_nics]
  count                 = length(local.InternalLb-Windows_nic_names)
  network_interface_id  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.InternalLb-Windows_nic_names, count.index)}"
  ip_configuration_name = "${element(local.InternalLb-Windows_nic_names, count.index)}-CFG"
  backend_address_pool_id = element(
    var.lb_backend_ids,
    element(local.InternalLb-Windows_id_lbs, count.index),
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_vms_nics_Public_Backend_ids" {
  depends_on            = [azurerm_network_interface.Windows_Vms_nics]
  count                 = length(local.PublicLb-Windows_nic_names)
  network_interface_id  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.PublicLb-Windows_nic_names, count.index)}"
  ip_configuration_name = "${element(local.PublicLb-Windows_nic_names, count.index)}-CFG"
  backend_address_pool_id = element(
    var.lb_backend_Public_ids,
    element(local.InternalLb-Windows_id_lbs, count.index),
  )
}

resource "azurerm_network_interface" "Windows_Vms_nics" {
  count                         = length(var.Windows_Vms)
  name                          = "${var.nic_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}${var.nic_suffix}"
  location                      = var.nic_location
  resource_group_name           = var.nic_resource_group_name
  network_security_group_id     = var.Windows_Vms[count.index]["Id_Nsg"] == 777 ? "" : element(var.nsgs_ids, var.Windows_Vms[count.index]["Id_Nsg"])
  enable_accelerated_networking = var.Windows_Vms[count.index]["enable_accelerated_networking"]

  ip_configuration {
    name = "${var.nic_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}${var.nic_suffix}-CFG"

    subnet_id                     = element(var.subnets_ids, var.Windows_Vms[count.index]["Id_Subnet"])
    private_ip_address_allocation = var.Windows_Vms[count.index]["static_ip"] == 777 ? "dynamic" : "static"
    private_ip_address            = var.Windows_Vms[count.index]["static_ip"] == 777 ? "" : var.Windows_Vms[count.index]["static_ip"]
    public_ip_address_id          = var.Windows_Vms[count.index]["Id_Ip_Public"] == 777 ? "" : var.Windows_Vms[count.index]["Id_Ip_Public"]
  }

  tags = var.nic_tags
}

