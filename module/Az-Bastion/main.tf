resource "azurerm_template_deployment" "bastion" {
  name                = "${var.bastionHostName}-dep"
  resource_group_name = var.resourceGroupName
  template_body = file(
    "${path.module}/AzureRmBastion_template.json",
  )
  deployment_mode = "Incremental"

  parameters = {
    location            = var.location
    resourceGroupName   = var.resourceGroupName
    bastionHostName     = var.bastionHostName
    subnetName          = var.subnetName
    publicIpAddressName = var.publicIpAddressName
    existingVNETName    = var.existingVNETName
    subnetAddressPrefix = var.subnetAddressPrefix
    tags                = jsonencode(var.tags)
  }
}
