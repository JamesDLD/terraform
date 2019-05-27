resource "azurerm_template_deployment" "paloaltos" {
  count               = length(var.pac)
  name                = "${var.pac[count.index]["suffix_name"]}-${var.pac[count.index]["id"]}-DEP"
  resource_group_name = var.pac_resource_group_name
  template_body = file(
    "${path.module}/AzureRmPaloAltoAz_template.json",
  )
  deployment_mode = "Incremental"

  parameters = {
    tags                           = jsonencode(var.pac_tags)
    vmName                         = "${var.pac[count.index]["suffix_name"]}${var.pac[count.index]["id"]}"
    vmAvailabilityZone             = var.pac[count.index]["vmAvailabilityZone"]
    vmSize                         = var.pac[count.index]["vmSize"]
    imageVersion                   = var.pac[count.index]["vmImageVersion"]
    imagePublisher                 = var.pac[count.index]["vmImagePublisher"]
    imageOffer                     = var.pac[count.index]["vmImageOffer"]
    imageSku                       = var.pac[count.index]["vmImageSku"]
    managed_disk_type              = var.pac[count.index]["vm_managed_disk_type"]
    enable_accelerated_networking  = var.pac[count.index]["enable_accelerated_networking"]
    virtualNetworkName             = var.pac_virtual_network_name
    virtualNetworkRGName           = var.pac_virtual_network_resource_group_name
    subnet0Name                    = var.pac[count.index]["subnet_mgmt_name"]
    subnet1Name                    = var.pac[count.index]["subnet_untrust_name"]
    subnet2Name                    = var.pac[count.index]["subnet_trust_name"]
    subnet0StartAddress            = var.pac[count.index]["subnet_mgmt_ip"]
    subnet1StartAddress            = var.pac[count.index]["subnet_untrust_ip"]
    subnet2StartAddress            = var.pac[count.index]["subnet_trust_ip"]
    adminUsername                  = var.adminUsername
    adminPassword                  = var.adminPassword
    nsgName                        = var.pac_nsg_name
    pip_domainNameLabel            = "${var.pac[count.index]["suffix_pip_domainNameLabel"]}-${var.pac[count.index]["suffix_name"]}${var.pac[count.index]["id"]}"
    boot_diag_storage_account_name = var.boot_diag_storage_account_name
  }
}

