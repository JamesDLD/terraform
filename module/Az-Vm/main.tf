# -
# - Locals variables
# -
locals {
  linux_vms                                  = [for x in var.vms : x if x.os_type == "linux"]
  linux_nics_with_internal_bp                = [for x in local.linux_vms : x if lookup(x, "internal_lb_iteration", null) != null]
  linux_nics_with_public_bp                  = [for x in local.linux_vms : x if lookup(x, "public_lb_iteration", null) != null]
  linux_vms_with_enable_enable_ip_forwarding = [for x in local.linux_vms : x if lookup(x, "enable_ip_forwarding", null) == true]
  linux_vms_to_backup                        = [for x in local.linux_vms : x if lookup(x, "BackupPolicyName", null) != null]
  windows_vms                                = [for x in var.vms : x if x.os_type == "windows"]
  windows_nics_with_internal_bp              = [for x in local.windows_vms : x if lookup(x, "internal_lb_iteration", null) != null]
  windows_nics_with_public_bp                = [for x in local.windows_vms : x if lookup(x, "public_lb_iteration", null) != null]
  windows_vms_to_backup                      = [for x in local.windows_vms : x if lookup(x, "BackupPolicyName", null) != null]
  custom_data_content                        = file("${path.module}/files/InitializeVM.ps1")
}

# -
# - Linux Network interfaces
# -
resource "azurerm_network_interface" "linux_nics" {
  count                         = length(local.linux_vms)
  name                          = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}-nic1"
  location                      = var.vm_location
  resource_group_name           = var.vm_resource_group_name
  network_security_group_id     = lookup(local.linux_vms[count.index], "security_group_iteration", null) == null ? null : element(var.nsgs_ids, lookup(local.linux_vms[count.index], "security_group_iteration"))
  internal_dns_name_label       = lookup(local.linux_vms[count.index], "internal_dns_name_label", null)
  enable_ip_forwarding          = lookup(local.linux_vms[count.index], "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(local.linux_vms[count.index], "enable_accelerated_networking", null)
  dns_servers                   = lookup(local.linux_vms[count.index], "dns_servers", null)

  ip_configuration {
    name                          = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}-nic1-CFG"
    subnet_id                     = lookup(local.linux_vms[count.index], "subnet_iteration", null) == null ? null : element(var.subnets_ids, lookup(local.linux_vms[count.index], "subnet_iteration"))
    private_ip_address_allocation = lookup(local.linux_vms[count.index], "static_ip", null) == null ? "dynamic" : "static"
    private_ip_address            = lookup(local.linux_vms[count.index], "static_ip", null)
    public_ip_address_id          = lookup(local.linux_vms[count.index], "public_ip_iteration", null) == null ? null : element(var.public_ip_ids, lookup(local.linux_vms[count.index], "public_ip_iteration"))
  }

  tags = var.vm_tags
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_nics_with_internal_backend_pools" {
  depends_on            = [azurerm_network_interface.linux_nics]
  count                 = length(local.linux_nics_with_internal_bp)
  network_interface_id  = [for x in azurerm_network_interface.linux_nics : x.id if x.name == "${var.vm_prefix}${local.linux_nics_with_internal_bp[count.index]["suffix_name"]}${local.linux_nics_with_internal_bp[count.index]["id"]}-nic1"][0]
  ip_configuration_name = "${var.vm_prefix}${local.linux_nics_with_internal_bp[count.index]["suffix_name"]}${local.linux_nics_with_internal_bp[count.index]["id"]}-nic1-CFG"
  backend_address_pool_id = element(
    var.internal_lb_backend_ids,
    local.linux_nics_with_internal_bp[count.index]["internal_lb_iteration"],
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "linux_nics_with_public_backend_pools" {
  depends_on            = [azurerm_network_interface.linux_nics]
  count                 = length(local.linux_nics_with_public_bp)
  network_interface_id  = [for x in azurerm_network_interface.linux_nics : x.id if x.name == "${var.vm_prefix}${local.linux_nics_with_public_bp[count.index]["suffix_name"]}${local.linux_nics_with_public_bp[count.index]["id"]}-nic1"][0]
  ip_configuration_name = "${var.vm_prefix}${local.linux_nics_with_public_bp[count.index]["suffix_name"]}${local.linux_nics_with_public_bp[count.index]["id"]}-nic1-CFG"
  backend_address_pool_id = element(
    var.public_lb_backend_ids,
    local.linux_nics_with_public_bp[count.index]["internal_lb_iteration"],
  )
}

# -
# - Linux Virtual Machines
# -

resource "azurerm_virtual_machine_extension" "linux_vms_with_enable_enable_ip_forwarding" {
  count                = length(local.linux_vms_with_enable_enable_ip_forwarding)
  name                 = "enable_accelerated_networking-for-${var.vm_prefix}${local.linux_vms_with_enable_enable_ip_forwarding[count.index]["suffix_name"]}${local.linux_vms_with_enable_enable_ip_forwarding[count.index]["id"]}"
  location             = azurerm_virtual_machine.linux_vms[count.index].location
  resource_group_name  = azurerm_network_interface.linux_nics[count.index].resource_group_name
  virtual_machine_name = "${var.vm_prefix}${local.linux_vms_with_enable_enable_ip_forwarding[count.index]["suffix_name"]}${local.linux_vms_with_enable_enable_ip_forwarding[count.index]["id"]}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sed -i 's/#net.ipv4.ip_forward/net.ipv4.ip_forward/g' /etc/sysctl.conf && sysctl -p"
    }
SETTINGS

  tags = var.vm_tags
}

resource "azurerm_virtual_machine" "linux_vms" {
  count = length(local.linux_vms)
  name = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}"
  location = azurerm_network_interface.linux_nics[count.index].location
  resource_group_name = azurerm_network_interface.linux_nics[count.index].resource_group_name
  network_interface_ids = [element(azurerm_network_interface.linux_nics.*.id, count.index)]
  zones = lookup(local.linux_vms[count.index], "zones", null)
  vm_size = local.linux_vms[count.index]["vm_size"]
  delete_os_disk_on_termination = lookup(local.linux_vms[count.index], "delete_os_disk_on_termination", true)
  delete_data_disks_on_termination = lookup(local.linux_vms[count.index], "delete_data_disks_on_termination", true)
  boot_diagnostics {
    enabled = var.sa_bootdiag_storage_uri == null ? "false" : "true"
    storage_uri = var.sa_bootdiag_storage_uri
  }


  os_profile_linux_config {
    disable_password_authentication = lookup(local.linux_vms[count.index], "disable_password_authentication", false)

    ssh_keys {
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_key
    }
  }

  storage_os_disk {
    name = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}-osdk"
    caching = lookup(local.linux_vms[count.index], "storage_os_disk_caching", "ReadWrite")
    create_option = lookup(local.linux_vms[count.index], "storage_os_disk_create_option", "FromImage")
    managed_disk_type = local.linux_vms[count.index]["managed_disk_type"]
  }


  storage_image_reference {
    id = lookup(local.linux_vms[count.index], "storage_image_reference_id", lookup(var.linux_storage_image_reference, "id", null))
    offer = lookup(local.linux_vms[count.index], "storage_image_reference_offer", lookup(var.linux_storage_image_reference, "offer", null))
    publisher = lookup(local.linux_vms[count.index], "storage_image_reference_publisher", lookup(var.linux_storage_image_reference, "publisher", null))
    sku = lookup(local.linux_vms[count.index], "storage_image_reference_sku", lookup(var.linux_storage_image_reference, "sku", null))
    version = lookup(local.linux_vms[count.index], "storage_image_reference_version", lookup(var.linux_storage_image_reference, "version", null))
  }

  dynamic "storage_data_disk" {
    for_each = lookup(local.linux_vms[count.index], "storage_data_disks", null)

    content {
      name = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}-dd${lookup(storage_data_disk.value, "id", "null")}"
      caching = lookup(storage_data_disk.value, "caching", null)
      create_option = lookup(storage_data_disk.value, "create_option", null)
      disk_size_gb = lookup(storage_data_disk.value, "disk_size_gb", null)
      lun = lookup(storage_data_disk.value, "lun", lookup(var.linux_storage_image_reference, "lun", lookup(storage_data_disk.value, "id", "null")))
      write_accelerator_enabled = lookup(storage_data_disk.value, "write_accelerator_enabled", null)
      managed_disk_type = lookup(storage_data_disk.value, "managed_disk_type", null)
      managed_disk_id = lookup(storage_data_disk.value, "managed_disk_id", null)
    }
  }

  os_profile {
    computer_name = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.vm_tags
}

# -
# - Linux Virtual Machines Backup
# -
resource "azurerm_recovery_services_protected_vm" "linux_vm_resources_to_backup" {
  count = var.rsv_id != "" ? length(local.linux_vms_to_backup) : "0"
  resource_group_name = element(split("/", var.rsv_id), 4)
  recovery_vault_name = element(split("/", var.rsv_id), 8)
  source_vm_id = [for x in azurerm_virtual_machine.linux_vms : x.id if x.name == "${var.vm_prefix}${local.linux_vms_to_backup[count.index]["suffix_name"]}${local.linux_vms_to_backup[count.index]["id"]}"][0]
  backup_policy_id = "${var.rsv_id}/backupPolicies/${local.linux_vms_to_backup[count.index]["BackupPolicyName"]}"
}

# -
# - Windows Network interfaces
# -
resource "azurerm_network_interface" "windows_nics" {
  count = length(local.windows_vms)
  name = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-nic1"
  location = var.vm_location
  resource_group_name = var.vm_resource_group_name
  network_security_group_id = lookup(local.windows_vms[count.index], "security_group_iteration", null) == null ? null : element(var.nsgs_ids, lookup(local.windows_vms[count.index], "security_group_iteration"))
  internal_dns_name_label = lookup(local.windows_vms[count.index], "internal_dns_name_label", null)
  enable_ip_forwarding = lookup(local.windows_vms[count.index], "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(local.windows_vms[count.index], "enable_accelerated_networking", null)
  dns_servers = lookup(local.windows_vms[count.index], "dns_servers", null)

  ip_configuration {
    name = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-nic1-CFG"
    subnet_id = lookup(local.windows_vms[count.index], "subnet_iteration", null) == null ? null : element(var.subnets_ids, lookup(local.windows_vms[count.index], "subnet_iteration"))
    private_ip_address_allocation = lookup(local.windows_vms[count.index], "static_ip", null) == null ? "dynamic" : "static"
    private_ip_address = lookup(local.windows_vms[count.index], "static_ip", null)
    public_ip_address_id = lookup(local.windows_vms[count.index], "public_ip_iteration", null) == null ? null : element(var.public_ip_ids, lookup(local.windows_vms[count.index], "public_ip_iteration"))
  }

  tags = var.vm_tags
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_nics_with_internal_backend_pools" {
  depends_on = [azurerm_network_interface.windows_nics]
  count = length(local.windows_nics_with_internal_bp)
  network_interface_id = [for x in azurerm_network_interface.windows_nics : x.id if x.name == "${var.vm_prefix}${local.windows_nics_with_internal_bp[count.index]["suffix_name"]}${local.windows_nics_with_internal_bp[count.index]["id"]}-nic1"][0]
  ip_configuration_name = "${var.vm_prefix}${local.windows_nics_with_internal_bp[count.index]["suffix_name"]}${local.windows_nics_with_internal_bp[count.index]["id"]}-nic1-CFG"
  backend_address_pool_id = element(
    var.internal_lb_backend_ids,
    local.windows_nics_with_internal_bp[count.index]["internal_lb_iteration"],
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_nics_with_public_backend_pools" {
  depends_on = [azurerm_network_interface.windows_nics]
  count = length(local.windows_nics_with_public_bp)
  network_interface_id = [for x in azurerm_network_interface.windows_nics : x.id if x.name == "${var.vm_prefix}${local.windows_nics_with_public_bp[count.index]["suffix_name"]}${local.windows_nics_with_public_bp[count.index]["id"]}-nic1"][0]
  ip_configuration_name = "${var.vm_prefix}${local.windows_nics_with_public_bp[count.index]["suffix_name"]}${local.windows_nics_with_public_bp[count.index]["id"]}-nic1-CFG"
  backend_address_pool_id = element(
    var.public_lb_backend_ids,
    local.windows_nics_with_public_bp[count.index]["internal_lb_iteration"],
  )
}

# -
# - Windows Virtual Machines
# -
resource "azurerm_virtual_machine" "windows_vms" {
  count = length(local.windows_vms)
  name = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}"
  location = azurerm_network_interface.windows_nics[count.index].location
  resource_group_name = azurerm_network_interface.windows_nics[count.index].resource_group_name
  network_interface_ids = [element(azurerm_network_interface.windows_nics.*.id, count.index)]
  zones = lookup(local.windows_vms[count.index], "zones", null)
  vm_size = local.windows_vms[count.index]["vm_size"]
  delete_os_disk_on_termination = lookup(local.windows_vms[count.index], "delete_os_disk_on_termination", true)
  delete_data_disks_on_termination = lookup(local.windows_vms[count.index], "delete_data_disks_on_termination", true)
  boot_diagnostics {
    enabled = var.sa_bootdiag_storage_uri == null ? "false" : "true"
    storage_uri = var.sa_bootdiag_storage_uri
  }

  os_profile_windows_config {
    provision_vm_agent = lookup(local.windows_vms[count.index], "provision_vm_agent", true)
    enable_automatic_upgrades = lookup(local.windows_vms[count.index], "enable_automatic_upgrades", true)
  }

  storage_os_disk {
    name = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-osdk"
    caching = lookup(local.windows_vms[count.index], "storage_os_disk_caching", "ReadWrite")
    create_option = lookup(local.windows_vms[count.index], "storage_os_disk_create_option", "FromImage")
    managed_disk_type = local.windows_vms[count.index]["managed_disk_type"]
  }


  storage_image_reference {
    id = lookup(local.windows_vms[count.index], "storage_image_reference_id", lookup(var.windows_storage_image_reference, "id", null))
    offer = lookup(local.windows_vms[count.index], "storage_image_reference_offer", lookup(var.windows_storage_image_reference, "offer", null))
    publisher = lookup(local.windows_vms[count.index], "storage_image_reference_publisher", lookup(var.windows_storage_image_reference, "publisher", null))
    sku = lookup(local.windows_vms[count.index], "storage_image_reference_sku", lookup(var.windows_storage_image_reference, "sku", null))
    version = lookup(local.windows_vms[count.index], "storage_image_reference_version", lookup(var.windows_storage_image_reference, "version", null))
  }

  dynamic "storage_data_disk" {
    for_each = lookup(local.windows_vms[count.index], "storage_data_disks", null)

    content {
      name = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-dd${lookup(storage_data_disk.value, "id", "null")}"
      caching = lookup(storage_data_disk.value, "caching", null)
      create_option = lookup(storage_data_disk.value, "create_option", null)
      disk_size_gb = lookup(storage_data_disk.value, "disk_size_gb", null)
      lun = lookup(storage_data_disk.value, "lun", lookup(var.windows_storage_image_reference, "lun", lookup(storage_data_disk.value, "id", "null")))
      write_accelerator_enabled = lookup(storage_data_disk.value, "write_accelerator_enabled", null)
      managed_disk_type = lookup(storage_data_disk.value, "managed_disk_type", null)
      managed_disk_id = lookup(storage_data_disk.value, "managed_disk_id", null)
    }
  }

  os_profile {
    computer_name = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.vm_tags
}

# -
# - Windows Virtual Machines Backup
# -
resource "azurerm_recovery_services_protected_vm" "windows_vm_resources_to_backup" {
  count = var.rsv_id != "" ? length(local.windows_vms_to_backup) : "0"
  resource_group_name = element(split("/", var.rsv_id), 4)
  recovery_vault_name = element(split("/", var.rsv_id), 8)
  source_vm_id = [for x in azurerm_virtual_machine.windows_vms : x.id if x.name == "${var.vm_prefix}${local.windows_vms_to_backup[count.index]["suffix_name"]}${local.windows_vms_to_backup[count.index]["id"]}"][0]
  backup_policy_id = "${var.rsv_id}/backupPolicies/${local.windows_vms_to_backup[count.index]["BackupPolicyName"]}"
}
