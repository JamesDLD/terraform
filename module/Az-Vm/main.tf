#Need improvment 1 : Fusion Windows and Linux

/*
#Monitoring
data "azurerm_log_analytics_workspace" "Infr" {
  name                = var.workspace_name
  resource_group_name = var.workspace_resource_group_name
}

resource "azurerm_log_analytics_solution" "ServiceMap" {
  count                 = var.disable_log_analytics_dependencies == "false" ? "1" : "0"
  solution_name         = "ServiceMap"
  location              = data.azurerm_log_analytics_workspace.Infr.location
  resource_group_name   = data.azurerm_log_analytics_workspace.Infr.resource_group_name
  workspace_resource_id = data.azurerm_log_analytics_workspace.Infr.id
  workspace_name        = data.azurerm_log_analytics_workspace.Infr.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ServiceMap"
  }
}
*/
#Linux_Vms
resource "null_resource" "linux_managed_disk_vm_ids" {
  count = length(var.Linux_DataDisks)

  triggers = {
    managed_disk_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.vm_resource_group_name}/providers/Microsoft.Compute/disks/${var.vm_prefix}${var.Linux_DataDisks[count.index]["suffix_name"]}${var.Linux_DataDisks[count.index]["id_disk"]}-datadk${var.Linux_DataDisks[count.index]["lun"]}"
    lun                = var.Linux_DataDisks[count.index]["lun"]
    caching            = var.Linux_DataDisks[count.index]["caching"]
    virtual_machine_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.vm_resource_group_name}/providers/Microsoft.Compute/virtualMachines/${var.vm_prefix}${var.Linux_DataDisks[count.index]["suffix_name"]}"
  }
}

locals {
  linux_managed_disk_ids = compact(
    null_resource.linux_managed_disk_vm_ids.*.triggers.managed_disk_id,
  )
  linux_luns     = compact(null_resource.linux_managed_disk_vm_ids.*.triggers.lun)
  linux_cachings = compact(null_resource.linux_managed_disk_vm_ids.*.triggers.caching)
  linux_virtual_machine_ids = compact(
    null_resource.linux_managed_disk_vm_ids.*.triggers.virtual_machine_id,
  )
}

resource "azurerm_managed_disk" "Linux_Vms_DataDisks" {
  count                = length(var.Linux_DataDisks)
  name                 = "${var.vm_prefix}${var.Linux_DataDisks[count.index]["suffix_name"]}${var.Linux_DataDisks[count.index]["id_disk"]}-datadk${var.Linux_DataDisks[count.index]["lun"]}"
  resource_group_name  = var.vm_resource_group_name
  create_option        = "Empty"
  location             = var.vm_location
  storage_account_type = var.Linux_DataDisks[count.index]["managed_disk_type"]
  disk_size_gb         = var.Linux_DataDisks[count.index]["disk_size_gb"]
  tags                 = var.vm_tags
  zones = compact(
    split(
      " ",
      var.Linux_DataDisks[count.index]["zone"] == 777 ? "" : var.Linux_DataDisks[count.index]["zone"],
    ),
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "Linux" {
  depends_on = [
    azurerm_virtual_machine.Linux_Vms,
    azurerm_managed_disk.Linux_Vms_DataDisks,
  ]
  count              = length(local.linux_managed_disk_ids)
  managed_disk_id    = element(local.linux_managed_disk_ids, count.index)
  virtual_machine_id = element(local.linux_virtual_machine_ids, count.index)
  lun                = element(local.linux_luns, count.index)
  caching            = element(local.linux_cachings, count.index)
}

/*
resource "azurerm_virtual_machine_extension" "DependencyAgentLinux" {
  depends_on = [
    azurerm_log_analytics_solution.ServiceMap,
    azurerm_virtual_machine.Linux_Vms,
    azurerm_managed_disk.Linux_Vms_DataDisks,
    azurerm_virtual_machine_data_disk_attachment.Linux,
  ]
  count    = var.disable_log_analytics_dependencies == "false" ? length(var.Linux_Vms) : "0"
  name     = element(azurerm_virtual_machine.Linux_Vms.*.name, count.index)
  location = var.vm_location
  resource_group_name = element(
    azurerm_virtual_machine.Linux_Vms.*.resource_group_name,
    count.index,
  )
  virtual_machine_name       = element(azurerm_virtual_machine.Linux_Vms.*.name, count.index)
  publisher                  = var.DependencyAgentLinux[0]["publisher"]
  type                       = var.DependencyAgentLinux[0]["type"]
  type_handler_version       = var.DependencyAgentLinux[0]["type_handler_version"]
  auto_upgrade_minor_version = var.DependencyAgentLinux[0]["auto_upgrade_minor_version"]
  tags                       = var.vm_tags
}

resource "azurerm_virtual_machine_extension" "OmsAgentForLinux" {
  depends_on = [
    azurerm_log_analytics_solution.ServiceMap,
    azurerm_virtual_machine_extension.DependencyAgentLinux,
  ]
  count    = var.disable_log_analytics_dependencies == "false" ? length(var.Linux_Vms) : "0"
  name     = "OMSExtension"
  location = var.vm_location
  resource_group_name = element(
    azurerm_virtual_machine.Linux_Vms.*.resource_group_name,
    count.index,
  )
  virtual_machine_name       = element(azurerm_virtual_machine.Linux_Vms.*.name, count.index)
  publisher                  = var.OmsAgentForLinux[0]["publisher"]
  type                       = var.OmsAgentForLinux[0]["type"]
  type_handler_version       = var.OmsAgentForLinux[0]["type_handler_version"]
  auto_upgrade_minor_version = var.OmsAgentForLinux[0]["auto_upgrade_minor_version"]

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
*/
resource "azurerm_virtual_machine" "Linux_Vms" {
count               = length(var.Linux_Vms)
name                = "${var.vm_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}"
location            = var.vm_location
resource_group_name = var.vm_resource_group_name
# TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
# force an interpolation expression to be interpreted as a list by wrapping it
# in an extra set of list brackets. That form was supported for compatibilty in
# v0.11, but is no longer supported in Terraform v0.12.
#
# If the expression in the following list itself returns a list, remove the
# brackets to avoid interpretation as a list of lists. If the expression
# returns a single list item then leave it as-is and remove this TODO comment.
network_interface_ids = [element(var.Linux_nics_ids, count.index)]
zones = compact(
split(
" ",
var.Linux_Vms[count.index]["zone"] == 777 ? "" : var.Linux_Vms[count.index]["zone"],
),
)
vm_size = var.Linux_Vms[count.index]["vm_size"]

# Uncomment this line to delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination = true

# Uncomment this line to delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = false

storage_os_disk {
name              = "${var.vm_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}osdk"
caching           = "ReadWrite"
create_option     = "FromImage"
managed_disk_type = var.Linux_Vms[count.index]["managed_disk_type"]
}

dynamic "storage_image_reference" {
for_each = [var.Linux_storage_image_reference]
content {
id        = lookup(storage_image_reference.value, "id", null)
offer     = lookup(storage_image_reference.value, "offer", null)
publisher = lookup(storage_image_reference.value, "publisher", null)
sku       = lookup(storage_image_reference.value, "sku", null)
version   = lookup(storage_image_reference.value, "version", null)
}
}

os_profile {
computer_name  = "${var.vm_prefix}${var.Linux_Vms[count.index]["suffix_name"]}${var.Linux_Vms[count.index]["id"]}"
admin_username = var.app_admin
admin_password = var.pass
}

os_profile_linux_config {
disable_password_authentication = var.disable_password_authentication

ssh_keys {
path     = "/home/${var.app_admin}/.ssh/authorized_keys"
key_data = var.ssh_key #"${file("./${var.ssh_key}")}"
}
}

boot_diagnostics {
enabled     = "true"
storage_uri = var.sa_bootdiag_storage_uri
}

tags = var.vm_tags
}

#Windows_Vms
resource "null_resource" "windows_managed_disk_vm_ids" {
count = length(var.Windows_DataDisks)

triggers = {
managed_disk_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.vm_resource_group_name}/providers/Microsoft.Compute/disks/${var.vm_prefix}${var.Windows_DataDisks[count.index]["suffix_name"]}${var.Windows_DataDisks[count.index]["id_disk"]}-datadk${var.Windows_DataDisks[count.index]["lun"]}"
lun                = var.Windows_DataDisks[count.index]["lun"]
caching            = var.Windows_DataDisks[count.index]["caching"]
virtual_machine_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.vm_resource_group_name}/providers/Microsoft.Compute/virtualMachines/${var.vm_prefix}${var.Windows_DataDisks[count.index]["suffix_name"]}"
}
}

locals {
windows_managed_disk_ids = compact(
null_resource.windows_managed_disk_vm_ids.*.triggers.managed_disk_id,
)
windows_luns     = compact(null_resource.windows_managed_disk_vm_ids.*.triggers.lun)
windows_cachings = compact(null_resource.windows_managed_disk_vm_ids.*.triggers.caching)
windows_virtual_machine_ids = compact(
null_resource.windows_managed_disk_vm_ids.*.triggers.virtual_machine_id,
)
}

resource "azurerm_managed_disk" "Windows_Vms_DataDisks" {
count                = length(var.Windows_DataDisks)
name                 = "${var.vm_prefix}${var.Windows_DataDisks[count.index]["suffix_name"]}${var.Windows_DataDisks[count.index]["id_disk"]}-datadk${var.Windows_DataDisks[count.index]["lun"]}"
resource_group_name  = var.vm_resource_group_name
create_option        = "Empty"
location             = var.vm_location
storage_account_type = var.Windows_DataDisks[count.index]["managed_disk_type"]
disk_size_gb         = var.Windows_DataDisks[count.index]["disk_size_gb"]
tags                 = var.vm_tags
zones = compact(
split(
" ",
var.Windows_DataDisks[count.index]["zone"] == 777 ? "" : var.Windows_DataDisks[count.index]["zone"],
),
)
}

resource "azurerm_virtual_machine_data_disk_attachment" "Windows" {
depends_on = [
azurerm_virtual_machine.Windows_Vms,
azurerm_managed_disk.Windows_Vms_DataDisks,
]
count              = length(local.windows_managed_disk_ids)
managed_disk_id    = element(local.windows_managed_disk_ids, count.index)
virtual_machine_id = element(local.windows_virtual_machine_ids, count.index)
lun                = element(local.windows_luns, count.index)
caching            = element(local.windows_cachings, count.index)
}

resource "azurerm_virtual_machine" "Windows_Vms" {
count               = length(var.Windows_Vms)
name                = "${var.vm_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}"
location            = var.vm_location
resource_group_name = var.vm_resource_group_name
# TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
# force an interpolation expression to be interpreted as a list by wrapping it
# in an extra set of list brackets. That form was supported for compatibilty in
# v0.11, but is no longer supported in Terraform v0.12.
#
# If the expression in the following list itself returns a list, remove the
# brackets to avoid interpretation as a list of lists. If the expression
# returns a single list item then leave it as-is and remove this TODO comment.
network_interface_ids = [element(var.Windows_nics_ids, count.index)] #network_interface_ids = ["${element(var.Windows_nics_ids,length(var.Linux_Vms)+count.index)}"]
zones = compact(
split(
" ",
var.Windows_Vms[count.index]["zone"] == 777 ? "" : var.Windows_Vms[count.index]["zone"],
),
)
vm_size = var.Windows_Vms[count.index]["vm_size"]

# Uncomment this line to delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination = true

# Uncomment this line to delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = false

#license_type = "${lookup(var.Windows_Vms[count.index], "license_type")}"

storage_os_disk {
  name              = "${var.vm_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}osdk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = var.Windows_Vms[count.index]["managed_disk_type"]
}
dynamic "storage_image_reference" {
  for_each = [var.Windows_storage_image_reference]
    content {
      id        = lookup(storage_image_reference.value, "id", null)
      offer     = lookup(storage_image_reference.value, "offer", null)
      publisher = lookup(storage_image_reference.value, "publisher", null)
      sku       = lookup(storage_image_reference.value, "sku", null)
      version   = lookup(storage_image_reference.value, "version", null)
    }
}
os_profile {
computer_name  = "${var.vm_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}"
admin_username = var.app_admin
admin_password = var.pass
#custom_data    = "Param($ComputerName = \"${var.vm_prefix}${lookup(var.Windows_Vms[count.index], "suffix_name")}${lookup(var.Windows_Vms[count.index], "id")}\") ${local.custom_data_content}"
}
os_profile_windows_config {
provision_vm_agent        = true
enable_automatic_upgrades = true

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
azurerm_key_vault_certificate.Windows_Vms_Certificates.*.secret_id,
count.index,
)
certificate_store = "My"
}
}
*/
boot_diagnostics {
enabled     = "true"
storage_uri = var.sa_bootdiag_storage_uri
}

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

tags = var.vm_tags
}

locals {
custom_data_content = file("${path.module}/files/InitializeVM.ps1")
}

/*
resource "azurerm_virtual_machine_extension" "DependencyAgentWindows" {
depends_on = [
azurerm_log_analytics_solution.ServiceMap,
azurerm_virtual_machine.Windows_Vms,
azurerm_managed_disk.Windows_Vms_DataDisks,
azurerm_virtual_machine_data_disk_attachment.Windows,
]
count    = var.disable_log_analytics_dependencies == "false" ? length(var.Windows_Vms) : "0"
name     = element(azurerm_virtual_machine.Windows_Vms.*.name, count.index)
location = var.vm_location
resource_group_name = element(
azurerm_virtual_machine.Windows_Vms.*.resource_group_name,
count.index,
)
virtual_machine_name       = element(azurerm_virtual_machine.Windows_Vms.*.name, count.index)
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
count    = var.disable_log_analytics_dependencies == "false" ? length(var.Windows_Vms) : "0"
name     = "OMSExtension"
location = var.vm_location
resource_group_name = element(
azurerm_virtual_machine.Windows_Vms.*.resource_group_name,
count.index,
)
virtual_machine_name       = element(azurerm_virtual_machine.Windows_Vms.*.name, count.index)
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

resource "azurerm_key_vault_certificate" "Windows_Vms_Certificates" {
  count        = length(var.Windows_Vms)
  name         = "${var.vm_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}-cert"
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

      subject            = "CN=${var.vm_prefix}${var.Windows_Vms[count.index]["suffix_name"]}${var.Windows_Vms[count.index]["id"]}"
      validity_in_months = 12
    }
  }
}
*/
