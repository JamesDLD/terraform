resource "azurerm_template_deployment" "resources_to_backup" {
  count               = "${length(var.resource_names)}"
  name                = "${element(var.resource_names,count.index)}-bck-DEP"
  resource_group_name = "${var.bck_rsv_resource_group_name}"

  template_body = <<DEPLOY
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "apiVersion": {
            "defaultValue": "2016-06-01",
            "type": "string"
        },
        "protectedItemType": {
            "defaultValue": "${var.bck_ProtectedItemType}",
            "type": "string"
        },
        "resourcegroupname": {
            "defaultValue": "${var.bck_rsv_resource_group_name}",
            "type": "string"
        },
        "vaultName": {
            "defaultValue": "${var.bck_rsv_name}",
            "type": "string"
        },
        "backuppolicyname": {
            "defaultValue": "${var.bck_BackupPolicyName}",
            "type": "string"
        },
        "location": {
            "defaultValue": "${var.bck_location}",
            "type": "string"
        },
        "fabricName": {
            "type": "string",
            "defaultValue": "Azure"
        },
        "resourcename": {
            "type": "string",
            "defaultValue": "${element(var.resource_names,count.index)}"
        },
        "resourceresourcegroupname": {
            "type": "string",
            "defaultValue": "${element(var.resource_group_names,count.index)}"
        },
        "resourceid": {
            "type": "string",
            "defaultValue": "${element(var.resource_ids,count.index)}" 
        }
    },
    "resources": [
      {
        "name": "[concat(parameters('vaultName'), '/', parameters('fabricName'), '/iaasvmcontainer;iaasvmcontainerv2;', parameters('resourceresourcegroupname'), ';', parameters('resourcename'), '/vm;iaasvmcontainerv2;', parameters('resourceresourcegroupname'), ';', parameters('resourcename'))]",
        "type": "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems",
        "apiVersion": "[parameters('apiVersion')]",
        "location": "[parameters('location')]",
        "tags": {},
        "properties": {
          "protectedItemType": "[parameters('protectedItemType')]",
          "policyId": "[resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', parameters('vaultName'), parameters('backuppolicyname'))]",
          "sourceResourceId": "[parameters('resourceid')]"
        }
      }
    ]
}
DEPLOY

  deployment_mode = "Incremental"
}

#"name": "[concat(parameters('vaultName'), '/', parameters('fabricName'), '/iaasvmcontainer;iaasvmcontainerv2;', parameters('resourcegroupname'), ';', parameters('resourcename'), '/vm;iaasvmcontainerv2;', parameters('resourceresourcegroupname'), ';', parameters('resourcename'))]",
#"name": "[concat(parameters('vaultName'), '/', parameters('fabricName'), '/iaasvmcontainer;iaasvmcontainerv2;', parameters('resourcegroupname'), ';', parameters('resourcename'), '/vm;iaasvmcontainerv2;', parameters('resourcegroupname'), ';', parameters('resourcename'))]",

