resource "azurerm_template_deployment" "vmbackups" {
  count               = "${length(var.Vms)}"
  name                = "${var.app_name}-${var.env_name}-${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")}-bck-DEP"
  resource_group_name = "${var.rg_apps_name}"
  depends_on          = ["azurerm_template_deployment.backup_policies"]

  template_body = <<DEPLOY
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "defaultValue": "${var.rg_apps_name}",
            "type": "string"
        },
        "vaultName": {
            "defaultValue": "${var.app_name}-${var.env_name}-rsv${lookup(var.Vms[count.index], "Id_BackupVault")}",
            "type": "string"
        },
        "location": {
            "defaultValue": "${var.location}",
            "type": "string"
        },
        "apiVersion": {
            "defaultValue": "2016-06-01",
            "type": "string"
        },
        "dailyRetentionDurationCount": {
            "type": "int",
            "metadata": {
                "description": "Number of days you want to retain the backup"
            },
			      "defaultValue": 104
        },
        "daysOfTheWeek": {
            "type": "array",
            "metadata": {
                "description": "Backup will run on array of Days like, Monday, Tuesday etc. Applies in Weekly retention only.3"
            },
			      "defaultValue": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        },   
        "weeklyRetentionDurationCount": {
            "type": "int",
            "metadata": {
                "description": "Number of weeks you want to retain the backup"
            },
			      "defaultValue": 4
        },     
        "monthlyRetentionDurationCount": {
            "type": "int",
            "metadata": {
                "description": "Number of months you want to retain the backup"
            },
			"defaultValue": 12
        },
        "monthsOfYear": {
            "type": "array",
            "metadata": {
                "description": "Array of Months for Yearly Retention"
            },
			"defaultValue":  ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        },
        "yearlyRetentionDurationCount": {
            "type": "int",
            "metadata": {
                "description": "Number of years you want to retain the backup"
            },
			"defaultValue": 2
        },
        "timeZone": {
            "type": "string",
            "defaultValue": "Romance Standard Time"
        },
        "fabricName": {
            "type": "string",
            "defaultValue": "Azure"
        }
    },
    "resources": [
      {
        "name": "[concat(parameters('vaultName'), '/', parameters('fabricName'), '/iaasvmcontainer;iaasvmcontainerv2;${var.rg_apps_name};${var.app_name}-${var.env_name}-${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")}/vm;iaasvmcontainerv2;${var.rg_apps_name};${var.app_name}-${var.env_name}-${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")}')]",
        "type": "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems",
        "apiVersion": "2016-12-01",
        "location": "[parameters('location')]",
        "tags": {},
        "properties": {
          "protectedItemType": "Microsoft.ClassicCompute/virtualMachines",
          "policyId": "[resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', parameters('vaultName'), '${lookup(var.Vms[count.index], "BackupPolicyName")}')]",
          "sourceResourceId": "${element(var.vms_ids,count.index)}"
        }
      }
    ]
}
DEPLOY

  deployment_mode = "Incremental"
}

#"sourceResourceId": "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_apps_name}/providers/Microsoft.Compute/virtualMachines/${var.app_name}-${var.env_name}-${lookup(var.Vms[count.index], "suffix_name")}${lookup(var.Vms[count.index], "id")}"

