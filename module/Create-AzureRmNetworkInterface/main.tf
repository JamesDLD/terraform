resource "azurerm_network_interface" "linux_vms_nics" {
  count                         = "${length(var.Linux_Vms)}"
  name                          = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}"
  location                      = "${var.nic_location}"
  resource_group_name           = "${var.nic_resource_group_name}"
  network_security_group_id     = "${"${lookup(var.Linux_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Linux_Vms[count.index], "Id_Nsg"))}"}"
  enable_accelerated_networking = "${lookup(var.Linux_Vms[count.index], "enable_accelerated_networking")}"

  ip_configuration {
    name                          = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"
    subnet_id                     = "${element(var.subnets_ids,lookup(var.Linux_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.Linux_Vms[count.index], "static_ip")}"
    public_ip_address_id          = "${ "${lookup(var.Linux_Vms[count.index], "Id_Ip_Public")}" == "777" ? "" : "${lookup(var.Linux_Vms[count.index], "Id_Ip_Public")}" }"

    load_balancer_backend_address_pools_ids = [
      "${compact(split(" ", "${lookup(var.Linux_Vms[count.index], "Id_Lb")}"  == "777" ? "" : "${element(var.lb_backend_ids,lookup(var.Linux_Vms[count.index], "Id_Lb"))}" ))}",
    ]

    #"${compact(split(" ", "${lookup(var.Linux_Vms[count.index], "Id_Lb_Public")}"  == "777" ? "" : "${element(var.lb_backend_Public_ids,lookup(var.Linux_Vms[count.index], "Id_Lb_Public"))}" ) ) }",
  }

  tags = "${var.nic_tags}"
}

resource "azurerm_network_interface" "Windows_Vms_nics" {
  count                         = "${length(var.Windows_Vms)}"
  name                          = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}"
  location                      = "${var.nic_location}"
  resource_group_name           = "${var.nic_resource_group_name}"
  network_security_group_id     = "${"${lookup(var.Windows_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Windows_Vms[count.index], "Id_Nsg"))}"}"
  enable_accelerated_networking = "${lookup(var.Windows_Vms[count.index], "enable_accelerated_networking")}"

  ip_configuration {
    name                          = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"
    subnet_id                     = "${element(var.subnets_ids,lookup(var.Windows_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.Windows_Vms[count.index], "static_ip")}"
    public_ip_address_id          = "${ "${lookup(var.Windows_Vms[count.index], "Id_Ip_Public")}" == "777" ? "" : "${lookup(var.Windows_Vms[count.index], "Id_Ip_Public")}" }"

    load_balancer_backend_address_pools_ids = [
      "${ compact(split(" ", "${lookup(var.Windows_Vms[count.index], "Id_Lb")}"  == "777" ? "" : "${element(var.lb_backend_ids,lookup(var.Windows_Vms[count.index], "Id_Lb"))}" ) ) }",
    ]

    #"${ compact(split(" ", "${lookup(var.Windows_Vms[count.index], "Id_Lb_Public")}"  == "777" ? "" : "${element(var.lb_backend_Public_ids,lookup(var.Windows_Vms[count.index], "Id_Lb_Public"))}" ) ) }",
  }

  tags = "${var.nic_tags}"
}
