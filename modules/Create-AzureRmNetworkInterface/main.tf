#Need improvment 1 : find a way to get condition on the LB usage
resource "azurerm_network_interface" "linux_vms_nics" {
  count               = "${length(var.Linux_Vms)}"
  name                = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}${var.nic_suffix}"
  location            = "${var.nic_location}"
  resource_group_name = "${var.nic_resource_group_name}"

  ip_configuration {
    name                          = "${var.nic_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"
    subnet_id                     = "${element(var.subnets_ids,lookup(var.Linux_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.Linux_Vms[count.index], "static_ip")}"

    /*
    # Condition testing ; Problème avec NULL ou []
    https://stackoverflow.com/questions/48301709/terraform-conditionally-creating-a-resource-within-a-loop
    */

    load_balancer_backend_address_pools_ids = []

    #load_balancer_backend_address_pools_ids = ["${element(var.lb_backend_ids,lookup(var.Linux_Vms[count.index], "Id_Lb"))}"]
  }

  tags = "${var.nic_tags}"
}

resource "azurerm_network_interface" "Windows_Vms_nics" {
  count               = "${length(var.Windows_Vms)}"
  name                = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}${var.nic_suffix}"
  location            = "${var.nic_location}"
  resource_group_name = "${var.nic_resource_group_name}"

  ip_configuration {
    name                          = "${var.nic_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${var.nic_suffix}-CFG"
    subnet_id                     = "${element(var.subnets_ids,lookup(var.Windows_Vms[count.index], "Id_Subnet"))}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.Windows_Vms[count.index], "static_ip")}"

    /*
    # Condition testing ; Problème avec NULL ou []
    https://stackoverflow.com/questions/48301709/terraform-conditionally-creating-a-resource-within-a-loop
    */

    load_balancer_backend_address_pools_ids = []

    #load_balancer_backend_address_pools_ids = ["${element(var.lb_backend_ids,lookup(var.Windows_Vms[count.index], "Id_Lb"))}"]
  }

  tags = "${var.nic_tags}"
}
