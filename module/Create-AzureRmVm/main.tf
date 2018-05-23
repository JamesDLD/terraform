#Need improvment 1 : Fusion Windows and Linux

#Linux_Vms
resource "azurerm_managed_disk" "Linux_Vms_DataDisks" {
  count                = "${length(var.Linux_Vms)}"
  name                 = "${var.vm_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}-datadk${lookup(var.Linux_Vms[count.index], "lun")}"
  resource_group_name  = "${var.vm_resource_group_name}"
  create_option        = "Empty"
  location             = "${var.vm_location}"
  storage_account_type = "${lookup(var.Linux_Vms[count.index], "managed_disk_type")}"
  disk_size_gb         = "${lookup(var.Linux_Vms[count.index], "disk_size_gb")}"
  tags                 = "${var.vm_tags}"
}

resource "azurerm_virtual_machine" "Linux_Vms" {
  count                 = "${length(var.Linux_Vms)}"
  name                  = "${var.vm_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}"
  location              = "${var.vm_location}"
  resource_group_name   = "${var.vm_resource_group_name}"
  network_interface_ids = ["${element(var.Linux_nics_ids,count.index)}"]
  availability_set_id   = "${"${lookup(var.Linux_Vms[count.index], "Id_Ava")}" == "777" ? "" : "${element(var.ava_set_ids,lookup(var.Linux_Vms[count.index], "Id_Ava"))}"}"
  vm_size               = "${lookup(var.Linux_Vms[count.index], "vm_size")}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = false

  storage_os_disk {
    name              = "${var.vm_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}osdk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.Linux_Vms[count.index], "managed_disk_type")}"
  }

  storage_image_reference {
    publisher = "${lookup(var.Linux_Vms[count.index], "publisher")}"
    offer     = "${lookup(var.Linux_Vms[count.index], "offer")}"
    sku       = "${lookup(var.Linux_Vms[count.index], "sku")}"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.vm_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}"
    admin_username = "${var.app_admin}"
    admin_password = "${var.pass}"
  }

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

  storage_data_disk {
    name            = "${element(azurerm_managed_disk.Linux_Vms_DataDisks.*.name,count.index)}"
    managed_disk_id = "${element(azurerm_managed_disk.Linux_Vms_DataDisks.*.id,count.index)}"
    create_option   = "Attach"
    lun             = "${lookup(var.Linux_Vms[count.index], "lun")}"
    disk_size_gb    = "${element(azurerm_managed_disk.Linux_Vms_DataDisks.*.disk_size_gb,count.index)}"
    caching         = "ReadWrite"
  }

  tags = "${var.vm_tags}"
}

#Windows_Vms
resource "azurerm_managed_disk" "Windows_Vms_DataDisks" {
  count                = "${length(var.Windows_Vms)}"
  name                 = "${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}-datadk${lookup(var.Windows_Vms[count.index], "lun")}"
  resource_group_name  = "${var.vm_resource_group_name}"
  create_option        = "Empty"
  location             = "${var.vm_location}"
  storage_account_type = "${lookup(var.Windows_Vms[count.index], "managed_disk_type")}"
  disk_size_gb         = "${lookup(var.Windows_Vms[count.index], "disk_size_gb")}"
  tags                 = "${var.vm_tags}"
}

resource "azurerm_virtual_machine" "Windows_Vms" {
  count                 = "${length(var.Windows_Vms)}"
  name                  = "${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}"
  location              = "${var.vm_location}"
  resource_group_name   = "${var.vm_resource_group_name}"
  network_interface_ids = ["${element(var.Windows_nics_ids,count.index)}"]                                                                                                      #network_interface_ids = ["${element(var.Windows_nics_ids,length(var.Linux_Vms)+count.index)}"]
  availability_set_id   = "${"${lookup(var.Windows_Vms[count.index], "Id_Ava")}" == "777" ? "" : "${element(var.ava_set_ids,lookup(var.Windows_Vms[count.index], "Id_Ava"))}"}"
  vm_size               = "${lookup(var.Windows_Vms[count.index], "vm_size")}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = false

  storage_os_disk {
    name              = "${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}osdk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.Windows_Vms[count.index], "managed_disk_type")}"
  }

  storage_image_reference {
    publisher = "${lookup(var.Windows_Vms[count.index], "publisher")}"
    offer     = "${lookup(var.Windows_Vms[count.index], "offer")}"
    sku       = "${lookup(var.Windows_Vms[count.index], "sku")}"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}"
    admin_username = "${var.app_admin}"
    admin_password = "${var.pass}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${var.sa_bootdiag_storage_uri}"
  }

  storage_data_disk {
    name            = "${element(azurerm_managed_disk.Windows_Vms_DataDisks.*.name,count.index)}"
    managed_disk_id = "${element(azurerm_managed_disk.Windows_Vms_DataDisks.*.id,count.index)}"
    create_option   = "Attach"
    lun             = "${lookup(var.Windows_Vms[count.index], "lun")}"
    disk_size_gb    = "${element(azurerm_managed_disk.Windows_Vms_DataDisks.*.disk_size_gb,count.index)}"
    caching         = "ReadWrite"
  }

  tags = "${var.vm_tags}"
}
