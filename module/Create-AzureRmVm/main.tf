#Need improvment 1 : Fusion Windows and Linux

#Linux_Vms
resource "azurerm_managed_disk" "Linux_Vms_DataDisks" {
  count                = "${length(var.Linux_DataDisks)}"
  name                 = "${var.vm_prefix}${lookup(var.Linux_DataDisks[count.index], "suffix_name")}${lookup(var.Linux_DataDisks[count.index], "id_disk")}-datadk${lookup(var.Linux_DataDisks[count.index], "lun")}"
  resource_group_name  = "${var.vm_resource_group_name}"
  create_option        = "Empty"
  location             = "${var.vm_location}"
  storage_account_type = "${lookup(var.Linux_DataDisks[count.index], "managed_disk_type")}"
  disk_size_gb         = "${lookup(var.Linux_DataDisks[count.index], "disk_size_gb")}"
  tags                 = "${var.vm_tags}"
  zones                = ["${compact(split(" ", "${lookup(var.Linux_DataDisks[count.index], "zone")}"  == "777" ? "" : "${lookup(var.Linux_DataDisks[count.index], "zone")}" ))}"]
}

resource "azurerm_virtual_machine_data_disk_attachment" "Linux" {
  count              = "${length(var.Linux_DataDisks)}"
  managed_disk_id    = "${element(azurerm_managed_disk.Linux_Vms_DataDisks.*.id,count.index)}"
  virtual_machine_id = "${element(azurerm_virtual_machine.Linux_Vms.*.id,lookup(var.Linux_DataDisks[count.index], "id"))}"
  lun                = "${lookup(var.Linux_DataDisks[count.index], "lun")}"
  caching            = "${lookup(var.Linux_DataDisks[count.index], "caching")}"
}

resource "azurerm_virtual_machine" "Linux_Vms" {
  count                 = "${length(var.Linux_Vms)}"
  name                  = "${var.vm_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}"
  location              = "${var.vm_location}"
  resource_group_name   = "${var.vm_resource_group_name}"
  network_interface_ids = ["${element(var.Linux_nics_ids,count.index)}"]
  zones                 = ["${compact(split(" ", "${lookup(var.Linux_Vms[count.index], "zone")}"  == "777" ? "" : "${lookup(var.Linux_Vms[count.index], "zone")}" ))}"]
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

  storage_image_reference = ["${var.Linux_storage_image_reference}"]

  os_profile {
    computer_name  = "${var.vm_prefix}${lookup(var.Linux_Vms[count.index], "suffix_name")}${lookup(var.Linux_Vms[count.index], "id")}"
    admin_username = "${var.app_admin}"
    admin_password = "${var.pass}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.app_admin}/.ssh/authorized_keys"
      key_data = "${var.ssh_key}"                              #"${file("./${var.ssh_key}")}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${var.sa_bootdiag_storage_uri}"
  }

  tags = "${var.vm_tags}"
}

#Windows_Vms
resource "azurerm_managed_disk" "Windows_Vms_DataDisks" {
  count                = "${length(var.Windows_DataDisks)}"
  name                 = "${var.vm_prefix}${lookup(var.Windows_DataDisks[count.index], "suffix_name")}${lookup(var.Windows_DataDisks[count.index], "id")}-datadk${lookup(var.Windows_DataDisks[count.index], "lun")}"
  resource_group_name  = "${var.vm_resource_group_name}"
  create_option        = "Empty"
  location             = "${var.vm_location}"
  storage_account_type = "${lookup(var.Windows_DataDisks[count.index], "managed_disk_type")}"
  disk_size_gb         = "${lookup(var.Windows_DataDisks[count.index], "disk_size_gb")}"
  tags                 = "${var.vm_tags}"
  zones                = ["${compact(split(" ", "${lookup(var.Windows_DataDisks[count.index], "zone")}"  == "777" ? "" : "${lookup(var.Windows_DataDisks[count.index], "zone")}" ))}"]
}

resource "azurerm_virtual_machine_data_disk_attachment" "Windows" {
  count              = "${length(var.Windows_DataDisks)}"
  managed_disk_id    = "${element(azurerm_managed_disk.Windows_Vms_DataDisks.*.id,count.index)}"
  virtual_machine_id = "${element(azurerm_virtual_machine.Windows_Vms.*.id,lookup(var.Windows_DataDisks[count.index], "id"))}"
  lun                = "${lookup(var.Windows_DataDisks[count.index], "lun")}"
  caching            = "${lookup(var.Windows_DataDisks[count.index], "caching")}"
}

resource "azurerm_virtual_machine" "Windows_Vms" {
  count                 = "${length(var.Windows_Vms)}"
  name                  = "${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}"
  location              = "${var.vm_location}"
  resource_group_name   = "${var.vm_resource_group_name}"
  network_interface_ids = ["${element(var.Windows_nics_ids,count.index)}"]                                                                                                  #network_interface_ids = ["${element(var.Windows_nics_ids,length(var.Linux_Vms)+count.index)}"]
  zones                 = ["${compact(split(" ", "${lookup(var.Windows_Vms[count.index], "zone")}"  == "777" ? "" : "${lookup(var.Windows_Vms[count.index], "zone")}" ))}"]
  vm_size               = "${lookup(var.Windows_Vms[count.index], "vm_size")}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = false

  #license_type = "${lookup(var.Windows_Vms[count.index], "license_type")}"

  storage_os_disk {
    name              = "${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}osdk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${lookup(var.Windows_Vms[count.index], "managed_disk_type")}"
  }
  storage_image_reference = ["${var.Windows_storage_image_reference}"]
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
  tags = "${var.vm_tags}"
}
