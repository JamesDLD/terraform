# -
# - Locals variables
# -
locals {
  linux_vms                     = [for x in var.vms : x if x.os_type == "linux"]
  linux_nics_with_internal_bp   = [for x in local.linux_vms : x if lookup(x, "internal_lb_iteration", null) != null]
  linux_nics_with_public_bp     = [for x in local.linux_vms : x if lookup(x, "public_lb_iteration", null) != null]
  windows_vms                   = [for x in var.vms : x if x.os_type == "windows"]
  windows_nics_with_internal_bp = [for x in local.windows_vms : x if lookup(x, "internal_lb_iteration", null) != null]
  windows_nics_with_public_bp   = [for x in local.windows_vms : x if lookup(x, "public_lb_iteration", null) != null]
  custom_data_content           = file("${path.module}/files/InitializeVM.ps1")
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

resource "azurerm_virtual_machine" "linux_vms" {
  count                            = length(local.linux_vms)
  name                             = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}"
  location                         = azurerm_network_interface.linux_nics[count.index].location
  resource_group_name              = azurerm_network_interface.linux_nics[count.index].resource_group_name
  network_interface_ids            = [element(azurerm_network_interface.linux_nics.*.id, count.index)]
  zones                            = lookup(local.linux_vms[count.index], "zones", null)
  vm_size                          = local.linux_vms[count.index]["vm_size"]
  delete_os_disk_on_termination    = lookup(local.linux_vms[count.index], "delete_os_disk_on_termination", true)
  delete_data_disks_on_termination = lookup(local.linux_vms[count.index], "delete_data_disks_on_termination", true)
  boot_diagnostics {
    enabled     = var.sa_bootdiag_storage_uri == null ? "false" : "true"
    storage_uri = var.sa_bootdiag_storage_uri
  }


  os_profile_linux_config {
    disable_password_authentication = lookup(local.linux_vms[count.index], "disable_password_authentication", false)

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = var.ssh_key
    }
  }

  storage_os_disk {
    name              = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}osdk"
    caching           = lookup(local.linux_vms[count.index], "storage_os_disk_caching", "ReadWrite")
    create_option     = lookup(local.linux_vms[count.index], "storage_os_disk_create_option", "FromImage")
    managed_disk_type = local.linux_vms[count.index]["managed_disk_type"]
  }


  storage_image_reference {
    id        = lookup(local.linux_vms[count.index], "storage_image_reference_id", lookup(var.linux_storage_image_reference, "id", null))
    offer     = lookup(local.linux_vms[count.index], "storage_image_reference_offer", lookup(var.linux_storage_image_reference, "offer", null))
    publisher = lookup(local.linux_vms[count.index], "storage_image_reference_publisher", lookup(var.linux_storage_image_reference, "publisher", null))
    sku       = lookup(local.linux_vms[count.index], "storage_image_reference_sku", lookup(var.linux_storage_image_reference, "sku", null))
    version   = lookup(local.linux_vms[count.index], "storage_image_reference_version", lookup(var.linux_storage_image_reference, "version", null))
  }

  dynamic "storage_data_disk" {
    for_each = lookup(local.linux_vms[count.index], "storage_data_disks", null)

    content {
      name                      = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}-dd${lookup(storage_data_disk.value, "id", "null")}"
      caching                   = lookup(storage_data_disk.value, "caching", null)
      create_option             = lookup(storage_data_disk.value, "create_option", null)
      disk_size_gb              = lookup(storage_data_disk.value, "disk_size_gb", null)
      lun                       = lookup(storage_data_disk.value, "lun", lookup(var.linux_storage_image_reference, "lun", lookup(storage_data_disk.value, "id", "null")))
      write_accelerator_enabled = lookup(storage_data_disk.value, "write_accelerator_enabled", null)
      managed_disk_type         = lookup(storage_data_disk.value, "managed_disk_type", null)
      managed_disk_id           = lookup(storage_data_disk.value, "managed_disk_id", null)
    }
  }

  os_profile {
    computer_name  = "${var.vm_prefix}${local.linux_vms[count.index]["suffix_name"]}${local.linux_vms[count.index]["id"]}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.vm_tags
}

# -
# - Windows Network interfaces
# -
resource "azurerm_network_interface" "windows_nics" {
  count                         = length(local.windows_vms)
  name                          = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-nic1"
  location                      = var.vm_location
  resource_group_name           = var.vm_resource_group_name
  network_security_group_id     = lookup(local.windows_vms[count.index], "security_group_iteration", null) == null ? null : element(var.nsgs_ids, lookup(local.windows_vms[count.index], "security_group_iteration"))
  internal_dns_name_label       = lookup(local.windows_vms[count.index], "internal_dns_name_label", null)
  enable_ip_forwarding          = lookup(local.windows_vms[count.index], "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(local.windows_vms[count.index], "enable_accelerated_networking", null)
  dns_servers                   = lookup(local.windows_vms[count.index], "dns_servers", null)

  ip_configuration {
    name                          = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-nic1-CFG"
    subnet_id                     = lookup(local.windows_vms[count.index], "subnet_iteration", null) == null ? null : element(var.subnets_ids, lookup(local.windows_vms[count.index], "subnet_iteration"))
    private_ip_address_allocation = lookup(local.windows_vms[count.index], "static_ip", null) == null ? "dynamic" : "static"
    private_ip_address            = lookup(local.windows_vms[count.index], "static_ip", null)
    public_ip_address_id          = lookup(local.windows_vms[count.index], "public_ip_iteration", null) == null ? null : element(var.public_ip_ids, lookup(local.windows_vms[count.index], "public_ip_iteration"))
  }

  tags = var.vm_tags
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_nics_with_internal_backend_pools" {
  depends_on            = [azurerm_network_interface.windows_nics]
  count                 = length(local.windows_nics_with_internal_bp)
  network_interface_id  = [for x in azurerm_network_interface.windows_nics : x.id if x.name == "${var.vm_prefix}${local.windows_nics_with_internal_bp[count.index]["suffix_name"]}${local.windows_nics_with_internal_bp[count.index]["id"]}-nic1"][0]
  ip_configuration_name = "${var.vm_prefix}${local.windows_nics_with_internal_bp[count.index]["suffix_name"]}${local.windows_nics_with_internal_bp[count.index]["id"]}-nic1-CFG"
  backend_address_pool_id = element(
    var.internal_lb_backend_ids,
    local.windows_nics_with_internal_bp[count.index]["internal_lb_iteration"],
  )
}

resource "azurerm_network_interface_backend_address_pool_association" "windows_nics_with_public_backend_pools" {
  depends_on            = [azurerm_network_interface.windows_nics]
  count                 = length(local.windows_nics_with_public_bp)
  network_interface_id  = [for x in azurerm_network_interface.windows_nics : x.id if x.name == "${var.vm_prefix}${local.windows_nics_with_public_bp[count.index]["suffix_name"]}${local.windows_nics_with_public_bp[count.index]["id"]}-nic1"][0]
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
  count                            = length(local.windows_vms)
  name                             = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}"
  location                         = azurerm_network_interface.windows_nics[count.index].location
  resource_group_name              = azurerm_network_interface.windows_nics[count.index].resource_group_name
  network_interface_ids            = [element(azurerm_network_interface.windows_nics.*.id, count.index)]
  zones                            = lookup(local.windows_vms[count.index], "zones", null)
  vm_size                          = local.windows_vms[count.index]["vm_size"]
  delete_os_disk_on_termination    = lookup(local.windows_vms[count.index], "delete_os_disk_on_termination", true)
  delete_data_disks_on_termination = lookup(local.windows_vms[count.index], "delete_data_disks_on_termination", true)
  boot_diagnostics {
    enabled     = var.sa_bootdiag_storage_uri == null ? "false" : "true"
    storage_uri = var.sa_bootdiag_storage_uri
  }


  os_profile_windows_config {
    provision_vm_agent        = lookup(local.windows_vms[count.index], "provision_vm_agent", true)
    enable_automatic_upgrades = lookup(local.windows_vms[count.index], "enable_automatic_upgrades", true)

    /*
    # Auto-Login's required to configure WinRM
    additional_unattend_config {
    pass         = "oobeSystem"
    component    = "Microsoft-Windows-Shell-Setup"
    setting_name = "AutoLogon"
    content      = "<AutoLogon><Password><Value>${var.pass}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.app_admin}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
    pass         = "oobeSystem"
    component    = "Microsoft-Windows-Shell-Setup"
    setting_name = "FirstLogonCommands"
    content      = file("${path.module}/files/FirstLogonCommands.xml")
    }
  */
  }

  /*
  os_profile_secrets {
  source_vault_id = var.key_vault_id

  vault_certificates {
  certificate_url = element(
  azurerm_key_vault_certificate.windows_vms_Certificates.*.secret_id,
  count.index,
  )
  certificate_store = "My"
  }
  }
  */

  /*
provisioner "remote-exec" {
connection {
host     = ""    # TF-UPGRADE-TODO: Set this to the IP address of the machine's primary network interface
type     = "ssh" # TF-UPGRADE-TODO: If this is a windows instance without an SSH server, change to "winrm"
user     = var.app_admin
password = var.pass
port     = 5986
https    = true
timeout  = "10m"

# NOTE: if you're using a real certificate, rather than a self-signed one, you'll want this set to `false`/to remove this.
insecure = true
}

inline = [
"cd C:\\Windows",
"dir",
]
}
*/

  storage_os_disk {
    name              = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}osdk"
    caching           = lookup(local.windows_vms[count.index], "storage_os_disk_caching", "ReadWrite")
    create_option     = lookup(local.windows_vms[count.index], "storage_os_disk_create_option", "FromImage")
    managed_disk_type = local.windows_vms[count.index]["managed_disk_type"]
  }


  storage_image_reference {
    id        = lookup(local.windows_vms[count.index], "storage_image_reference_id", lookup(var.windows_storage_image_reference, "id", null))
    offer     = lookup(local.windows_vms[count.index], "storage_image_reference_offer", lookup(var.windows_storage_image_reference, "offer", null))
    publisher = lookup(local.windows_vms[count.index], "storage_image_reference_publisher", lookup(var.windows_storage_image_reference, "publisher", null))
    sku       = lookup(local.windows_vms[count.index], "storage_image_reference_sku", lookup(var.windows_storage_image_reference, "sku", null))
    version   = lookup(local.windows_vms[count.index], "storage_image_reference_version", lookup(var.windows_storage_image_reference, "version", null))
  }

  dynamic "storage_data_disk" {
    for_each = lookup(local.windows_vms[count.index], "storage_data_disks", null)

    content {
      name                      = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-dd${lookup(storage_data_disk.value, "id", "null")}"
      caching                   = lookup(storage_data_disk.value, "caching", null)
      create_option             = lookup(storage_data_disk.value, "create_option", null)
      disk_size_gb              = lookup(storage_data_disk.value, "disk_size_gb", null)
      lun                       = lookup(storage_data_disk.value, "lun", lookup(var.windows_storage_image_reference, "lun", lookup(storage_data_disk.value, "id", "null")))
      write_accelerator_enabled = lookup(storage_data_disk.value, "write_accelerator_enabled", null)
      managed_disk_type         = lookup(storage_data_disk.value, "managed_disk_type", null)
      managed_disk_id           = lookup(storage_data_disk.value, "managed_disk_id", null)
    }
  }

  os_profile {
    computer_name  = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}"
    admin_username = var.admin_username
    admin_password = var.admin_password
    #custom_data    = "Param($ComputerName = \"${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}\") ${local.custom_data_content}"
  }

  tags = var.vm_tags
}

/*
resource "azurerm_virtual_machine_extension" "DependencyAgentWindows" {
depends_on = [
azurerm_log_analytics_solution.ServiceMap,
azurerm_virtual_machine.windows_vms
]
count    = var.disable_log_analytics_dependencies == "false" ? length(local.windows_vms) : "0"
name     = element(azurerm_virtual_machine.windows_vms.*.name, count.index)
location = var.vm_location
resource_group_name = element(
azurerm_virtual_machine.windows_vms.*.resource_group_name,
count.index,
)
virtual_machine_name       = element(azurerm_virtual_machine.windows_vms.*.name, count.index)
publisher                  = var.DependencyAgentWindows[0]["publisher"]
type                       = var.DependencyAgentWindows[0]["type"]
type_handler_version       = var.DependencyAgentWindows[0]["type_handler_version"]
auto_upgrade_minor_version = var.DependencyAgentWindows[0]["auto_upgrade_minor_version"]
tags                       = var.vm_tags
}

resource "azurerm_virtual_machine_extension" "OmsAgentForWindows" {
depends_on = [
azurerm_log_analytics_solution.ServiceMap,
azurerm_virtual_machine_extension.DependencyAgentLinux,
]
count    = var.disable_log_analytics_dependencies == "false" ? length(local.windows_vms) : "0"
name     = "OMSExtension"
location = var.vm_location
resource_group_name = element(
azurerm_virtual_machine.windows_vms.*.resource_group_name,
count.index,
)
virtual_machine_name       = element(azurerm_virtual_machine.windows_vms.*.name, count.index)
publisher                  = var.OmsAgentForWindows[0]["publisher"]
type                       = var.OmsAgentForWindows[0]["type"]
type_handler_version       = var.OmsAgentForWindows[0]["type_handler_version"]
auto_upgrade_minor_version = var.OmsAgentForWindows[0]["auto_upgrade_minor_version"]

settings = <<-BASE_SETTINGS
 {
   "workspaceId" : "${data.azurerm_log_analytics_workspace.Infr.workspace_id}"
 }
BASE_SETTINGS


protected_settings = <<-PROTECTED_SETTINGS
 {
   "workspaceKey" : "${data.azurerm_log_analytics_workspace.Infr.primary_shared_key}"
 }
PROTECTED_SETTINGS

}

resource "azurerm_key_vault_certificate" "windows_vms_Certificates" {
  count        = length(local.windows_vms)
  name         = "${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}-cert"
  key_vault_id = var.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject            = "CN=${var.vm_prefix}${local.windows_vms[count.index]["suffix_name"]}${local.windows_vms[count.index]["id"]}"
      validity_in_months = 12
    }
  }
}
*/

