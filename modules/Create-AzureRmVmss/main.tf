#Need improvment 1 : Fusion Windows and Linux
resource "azurerm_virtual_machine_scale_set" "Linux_Ss_Vms" {
  count               = "${length(var.Linux_Ss_Vms)}"
  name                = "${var.vmss_prefix}${lookup(var.Linux_Ss_Vms[count.index], "suffix_name")}${lookup(var.Linux_Ss_Vms[count.index], "id")}"
  location            = "${var.vmss_location}"
  resource_group_name = "${var.vmss_resource_group_name}"
  upgrade_policy_mode = "${lookup(var.Linux_Ss_Vms[count.index], "upgrade_policy_mode")}"

  sku {
    name     = "${lookup(var.Linux_Ss_Vms[count.index], "sku_name")}"
    tier     = "${lookup(var.Linux_Ss_Vms[count.index], "sku_tier")}"
    capacity = "${lookup(var.Linux_Ss_Vms[count.index], "sku_capacity")}"
  }

  storage_profile_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.Linux_Ss_Vms[count.index], "managed_disk_type")}"
  }

  storage_profile_image_reference {
    publisher = "${lookup(var.Linux_Ss_Vms[count.index], "publisher")}"
    offer     = "${lookup(var.Linux_Ss_Vms[count.index], "offer")}"
    sku       = "${lookup(var.Linux_Ss_Vms[count.index], "sku")}"
    version   = "latest"
  }

  os_profile {
    computer_name_prefix = "${var.vmss_prefix}${lookup(var.Linux_Ss_Vms[count.index], "suffix_name")}"
    admin_username       = "${var.app_admin}"
    admin_password       = "${var.pass}"
  }

  os_profile_windows_config = []

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.app_admin}/.ssh/authorized_keys"
      key_data = "${var.ssh_key}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${var.sa_bootdiag_storage_uri}"
  }

  storage_profile_data_disk {
    create_option     = "Empty"
    lun               = "${lookup(var.Linux_Ss_Vms[count.index], "lun")}"
    caching           = "ReadWrite"
    disk_size_gb      = "${lookup(var.Linux_Ss_Vms[count.index], "disk_size_gb")}"
    managed_disk_type = "${lookup(var.Linux_Ss_Vms[count.index], "managed_disk_type")}"
  }

  network_profile {
    name                      = "${var.vmss_prefix}${lookup(var.Linux_Ss_Vms[count.index], "suffix_name")}${lookup(var.Linux_Ss_Vms[count.index], "id")}-netpf1"
    primary                   = true
    network_security_group_id = "${"${lookup(var.Linux_Ss_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Linux_Ss_Vms[count.index], "Id_Nsg"))}"}"

    ip_configuration {
      name                                   = "${var.vmss_prefix}${lookup(var.Linux_Ss_Vms[count.index], "suffix_name")}${lookup(var.Linux_Ss_Vms[count.index], "id")}-ipcfg1"
      subnet_id                              = "${element(var.subnets_ids,lookup(var.Linux_Ss_Vms[count.index], "Id_Subnet"))}"
      load_balancer_backend_address_pool_ids = ["${element(var.lb_backend_ids,lookup(var.Linux_Ss_Vms[count.index], "Id_Lb"))}"]
    }
  }

  tags = "${var.vmss_tags}"
}

resource "azurerm_virtual_machine_scale_set" "Windows_Ss_Vms" {
  count               = "${length(var.Windows_Ss_Vms)}"
  name                = "${var.vmss_prefix}${lookup(var.Windows_Ss_Vms[count.index], "suffix_name")}${lookup(var.Windows_Ss_Vms[count.index], "id")}"
  location            = "${var.vmss_location}"
  resource_group_name = "${var.vmss_resource_group_name}"
  upgrade_policy_mode = "${lookup(var.Windows_Ss_Vms[count.index], "upgrade_policy_mode")}"

  sku {
    name     = "${lookup(var.Windows_Ss_Vms[count.index], "sku_name")}"
    tier     = "${lookup(var.Windows_Ss_Vms[count.index], "sku_tier")}"
    capacity = "${lookup(var.Windows_Ss_Vms[count.index], "sku_capacity")}"
  }

  storage_profile_os_disk {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.Windows_Ss_Vms[count.index], "managed_disk_type")}"
  }

  storage_profile_image_reference {
    publisher = "${lookup(var.Windows_Ss_Vms[count.index], "publisher")}"
    offer     = "${lookup(var.Windows_Ss_Vms[count.index], "offer")}"
    sku       = "${lookup(var.Windows_Ss_Vms[count.index], "sku")}"
    version   = "latest"
  }

  os_profile {
    computer_name_prefix = "${lookup(var.Windows_Ss_Vms[count.index], "suffix_name")}" #Windows computer name prefix cannot be more than 9 characters long
    admin_username       = "${var.app_admin}"
    admin_password       = "${var.pass}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  os_profile_linux_config = []

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${var.sa_bootdiag_storage_uri}"
  }

  storage_profile_data_disk {
    create_option     = "Empty"
    lun               = "${lookup(var.Windows_Ss_Vms[count.index], "lun")}"
    caching           = "ReadWrite"
    disk_size_gb      = "${lookup(var.Windows_Ss_Vms[count.index], "disk_size_gb")}"
    managed_disk_type = "${lookup(var.Windows_Ss_Vms[count.index], "managed_disk_type")}"
  }

  network_profile {
    name                      = "${var.vmss_prefix}${lookup(var.Windows_Ss_Vms[count.index], "suffix_name")}${lookup(var.Windows_Ss_Vms[count.index], "id")}-netpf1"
    primary                   = true
    network_security_group_id = "${"${lookup(var.Windows_Ss_Vms[count.index], "Id_Nsg")}" == "777" ? "" : "${element(var.nsgs_ids,lookup(var.Windows_Ss_Vms[count.index], "Id_Nsg"))}"}"

    ip_configuration {
      name                                   = "${var.vmss_prefix}${lookup(var.Windows_Ss_Vms[count.index], "suffix_name")}${lookup(var.Windows_Ss_Vms[count.index], "id")}-ipcfg1"
      subnet_id                              = "${element(var.subnets_ids,lookup(var.Windows_Ss_Vms[count.index], "Id_Subnet"))}"
      load_balancer_backend_address_pool_ids = ["${element(var.lb_backend_ids,lookup(var.Windows_Ss_Vms[count.index], "Id_Lb"))}"]
    }
  }

  tags = "${var.vmss_tags}"
}
