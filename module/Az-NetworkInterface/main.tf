#Linux
resource "null_resource" "linux_vms_nics" {
  count = "${length(var.Linux_Vms)}"

  triggers = {
    InternalLb-Linux_nic_name = "${"${lookup(var.Linux_Vms[count.index], "Id_Lb")}" == "777" ? 
                                "" : 
                                "${var.use_old_ip_configuration_name}" == "false" ? 
                                  "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}" : 
                                  "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${var.nic_suffix}"}"

    InternalLb-Linux_id_lb = "${"${lookup(var.Linux_Vms[count.index], "Id_Lb")}" == "777" ? 
                                "" : "${lookup(var.Linux_Vms[count.index], "Id_Lb")}"}"

    PublicLb-Linux_nic_name = "${"${lookup(var.Linux_Vms[count.index], "Id_Lb_Public")}" == "777" ? 
                                "" : 
                                "${var.use_old_ip_configuration_name}" == "false" ? 
                                  "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}" : 
                                  "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${var.nic_suffix}"}"

    PublicLb-Linux_id_lb = "${"${lookup(var.Linux_Vms[count.index], "Id_Lb_Public")}" == "777" ? 
                                "" : "${lookup(var.Linux_Vms[count.index], "Id_Lb_Public")}"}"
  }
}

locals {
  InternalLb-Linux_nic_names = ["${compact(null_resource.linux_vms_nics.*.triggers.InternalLb-Linux_nic_name)}"]
  InternalLb-Linux_id_lbs    = ["${compact(null_resource.linux_vms_nics.*.triggers.InternalLb-Linux_id_lb)}"]
  PublicLb-Linux_nic_names   = ["${compact(null_resource.linux_vms_nics.*.triggers.PublicLb-Linux_nic_name)}"]
  PublicLb-Linux_id_lbs      = ["${compact(null_resource.linux_vms_nics.*.triggers.PublicLb-Linux_id_lb)}"]
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_vms_nics_Internal_Backend_ids" {
  depends_on              = ["azurerm_network_interface.linux_vms_nics"]
  count                   = "${ length(local.InternalLb-Linux_nic_names) }"
  network_interface_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.InternalLb-Linux_nic_names,count.index)}"
  ip_configuration_name   = "${element(local.InternalLb-Linux_nic_names,count.index)}-CFG"
  backend_address_pool_id = "${element(var.lb_backend_ids,element(local.InternalLb-Linux_id_lbs,count.index))}"
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_vms_nics_Public_Backend_ids" {
  depends_on              = ["azurerm_network_interface.linux_vms_nics"]
  count                   = "${ length(local.PublicLb-Linux_nic_names) }"
  network_interface_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.PublicLb-Linux_nic_names,count.index)}"
  ip_configuration_name   = "${element(local.PublicLb-Linux_nic_names,count.index)}-CFG"
  backend_address_pool_id = "${element(var.lb_backend_Public_ids,element(local.InternalLb-Linux_id_lbs,count.index))}"
}

resource "azurerm_network_interface" "linux_vms_nics" {
  count                         = "${length(var.Linux_Vms)}"
  name                          = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}"
  location                      = "${var.nic_location}"
  resource_group_name           = "${var.nic_resource_group_name}"
  network_security_group_id     = "${"${lookup(var.Linux_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Linux_Vms[count.index], "Id_Nsg"))}"}"
  enable_accelerated_networking = "${lookup(var.Linux_Vms[count.index], "enable_accelerated_networking")}"

  ip_configuration {
    name = "${"${var.use_old_ip_configuration_name}" == "false" ? 
                                "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}-CFG" : 
                                "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"}"

    subnet_id                     = "${element(var.subnets_ids,lookup(var.Linux_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "${ "${lookup(var.Linux_Vms[count.index], "static_ip")}" == "777" ? "dynamic" : "static" }"
    private_ip_address            = "${ "${lookup(var.Linux_Vms[count.index], "static_ip")}" == "777" ? "" : "${lookup(var.Linux_Vms[count.index], "static_ip")}" }"
    public_ip_address_id          = "${ "${lookup(var.Linux_Vms[count.index], "Id_Ip_Public")}" == "777" ? "" : "${lookup(var.Linux_Vms[count.index], "Id_Ip_Public")}" }"
  }

  tags = "${var.nic_tags}"
}

#Windows
resource "null_resource" "windows_vms_nics" {
  count = "${length(var.Windows_Vms)}"

  triggers = {
    InternalLb-Windows_nic_name = "${"${lookup(var.Windows_Vms[count.index], "Id_Lb")}" == "777" ? 
                                "" : 
                                "${var.use_old_ip_configuration_name}" == "false" ? 
                                  "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}" : 
                                  "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${var.nic_suffix}"}"

    InternalLb-Windows_id_lb = "${"${lookup(var.Windows_Vms[count.index], "Id_Lb")}" == "777" ? 
                                "" : "${lookup(var.Windows_Vms[count.index], "Id_Lb")}"}"

    PublicLb-Windows_nic_name = "${"${lookup(var.Windows_Vms[count.index], "Id_Lb_Public")}" == "777" ? 
                                "" : 
                                "${var.use_old_ip_configuration_name}" == "false" ? 
                                  "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}" : 
                                  "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${var.nic_suffix}"}"

    PublicLb-Windows_id_lb = "${"${lookup(var.Windows_Vms[count.index], "Id_Lb_Public")}" == "777" ? 
                                "" : "${lookup(var.Windows_Vms[count.index], "Id_Lb_Public")}"}"
  }
}

locals {
  InternalLb-Windows_nic_names = ["${compact(null_resource.windows_vms_nics.*.triggers.InternalLb-Windows_nic_name)}"]
  InternalLb-Windows_id_lbs    = ["${compact(null_resource.windows_vms_nics.*.triggers.InternalLb-Windows_id_lb)}"]
  PublicLb-Windows_nic_names   = ["${compact(null_resource.windows_vms_nics.*.triggers.PublicLb-Windows_nic_name)}"]
  PublicLb-Windows_id_lbs      = ["${compact(null_resource.windows_vms_nics.*.triggers.PublicLb-Windows_id_lb)}"]
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_vms_nics_Internal_Backend_ids" {
  depends_on              = ["azurerm_network_interface.Windows_Vms_nics"]
  count                   = "${ length(local.InternalLb-Windows_nic_names) }"
  network_interface_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.InternalLb-Windows_nic_names,count.index)}"
  ip_configuration_name   = "${element(local.InternalLb-Windows_nic_names,count.index)}-CFG"
  backend_address_pool_id = "${element(var.lb_backend_ids,element(local.InternalLb-Windows_id_lbs,count.index))}"
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_vms_nics_Public_Backend_ids" {
  depends_on              = ["azurerm_network_interface.Windows_Vms_nics"]
  count                   = "${ length(local.PublicLb-Windows_nic_names) }"
  network_interface_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.nic_resource_group_name}/providers/Microsoft.Network/networkInterfaces/${element(local.PublicLb-Windows_nic_names,count.index)}"
  ip_configuration_name   = "${element(local.PublicLb-Windows_nic_names,count.index)}-CFG"
  backend_address_pool_id = "${element(var.lb_backend_Public_ids,element(local.InternalLb-Windows_id_lbs,count.index))}"
}

resource "azurerm_network_interface" "Windows_Vms_nics" {
  count                         = "${length(var.Windows_Vms)}"
  name                          = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}"
  location                      = "${var.nic_location}"
  resource_group_name           = "${var.nic_resource_group_name}"
  network_security_group_id     = "${"${lookup(var.Windows_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Windows_Vms[count.index], "Id_Nsg"))}"}"
  enable_accelerated_networking = "${lookup(var.Windows_Vms[count.index], "enable_accelerated_networking")}"

  ip_configuration {
    name = "${"${var.use_old_ip_configuration_name}" == "false" ? 
                                "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}-CFG" : 
                                "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"}"

    subnet_id                     = "${element(var.subnets_ids,lookup(var.Windows_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "${ "${lookup(var.Windows_Vms[count.index], "static_ip")}" == "777" ? "dynamic" : "static" }"
    private_ip_address            = "${ "${lookup(var.Windows_Vms[count.index], "static_ip")}" == "777" ? "" : "${lookup(var.Windows_Vms[count.index], "static_ip")}" }"
    public_ip_address_id          = "${ "${lookup(var.Windows_Vms[count.index], "Id_Ip_Public")}" == "777" ? "" : "${lookup(var.Windows_Vms[count.index], "Id_Ip_Public")}" }"
  }

  tags = "${var.nic_tags}"
}
