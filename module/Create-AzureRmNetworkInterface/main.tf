#Need improvment 1 : find a way to get condition on the LB usage

resource "azurerm_network_interface" "linux_vms_nics" {
  count                     = "${length(var.Linux_Vms)}"
  name                      = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}"
  location                  = "${var.nic_location}"
  resource_group_name       = "${var.nic_resource_group_name}"
  network_security_group_id = "${"${lookup(var.Linux_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Linux_Vms[count.index], "Id_Nsg"))}"}"

  ip_configuration {
    name                          = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"
    subnet_id                     = "${element(var.subnets_ids,lookup(var.Linux_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.Linux_Vms[count.index], "static_ip")}"

    #Below code works but only permit to have a standalone nic, not linked to any lb
    load_balancer_backend_address_pools_ids = []

    #Below code works but only permit to have a nic linked to an lb
    #load_balancer_backend_address_pools_ids = ["${element(var.lb_backend_ids,lookup(var.Linux_Vms[count.index], "Id_Lb"))}"]

    #Below codes don't work if "Id_Lb"  == "777", it fails to send a null list like []
    #load_balancer_backend_address_pools_ids = "${split(" ", "${lookup(var.Linux_Vms[count.index], "Id_Lb")}"  == "777" ? "" : "${element(var.list_lb_backend_ids,lookup(var.Linux_Vms[count.index], "Id_Lb"))}")}"
  }

  tags = "${var.nic_tags}"
}

resource "azurerm_network_interface" "Windows_Vms_nics" {
  count                     = "${length(var.Windows_Vms)}"
  name                      = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}"
  location                  = "${var.nic_location}"
  resource_group_name       = "${var.nic_resource_group_name}"
  network_security_group_id = "${"${lookup(var.Windows_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Windows_Vms[count.index], "Id_Nsg"))}"}"

  ip_configuration {
    name                                    = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"
    subnet_id                               = "${element(var.subnets_ids,lookup(var.Windows_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation           = "static"
    private_ip_address                      = "${lookup(var.Windows_Vms[count.index], "static_ip")}"
    load_balancer_backend_address_pools_ids = []

    #"${element(var.lb_backend_ids,lookup(var.Windows_Vms[count.index], "Id_Lb"))}"]
  }

  tags = "${var.nic_tags}"
}
