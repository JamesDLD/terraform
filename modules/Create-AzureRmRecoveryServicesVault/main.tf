resource "azurerm_template_deployment" "backup_vaults" {
  count               = "${length(var.recovery_service_vaults)}"
  name                = "${var.app_name}-${var.env_name}-rsv${lookup(var.recovery_service_vaults[count.index], "Id")}-DEP"
  resource_group_name = "${var.rg_apps_name}"

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
            "defaultValue": "${var.app_name}-${var.env_name}-rsv${lookup(var.recovery_service_vaults[count.index], "Id")}",
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
            "apiVersion": "[parameters('apiVersion')]",
            "name": "[parameters('vaultName')]",
            "location": "[parameters('location')]",
            "type": "Microsoft.RecoveryServices/vaults",
            "sku": {
                "name": "RS0",
                "tier": "Standard"
            },
            "properties": {}
        }
    ]
}
DEPLOY

  deployment_mode = "Incremental"
}

resource "azurerm_template_deployment" "backup_policies" {
  count               = "${length(var.backup_policies)}"
  name                = "${var.app_name}-${var.env_name}-bp${lookup(var.backup_policies[count.index], "Id_BackupPolicy")}-DEP"
  resource_group_name = "${var.rg_apps_name}"
  depends_on          = ["azurerm_template_deployment.backup_vaults"]

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vaultName": {
            "defaultValue": "${var.app_name}-${var.env_name}-rsv${lookup(var.backup_policies[count.index], "Id_BackupVault")}",
            "type": "string",
            "metadata": {
                "description": "Name of the Recovery Services Vault"
            }
        },
        "policyName": {
            "defaultValue": "${lookup(var.backup_policies[count.index], "Name")}",
            "type": "string",
            "metadata": {
                "description": "Name of the Backup Policy"
            }
        },
        "scheduleRunTimes": {
            "defaultValue": ["${lookup(var.backup_policies[count.index], "scheduleRunTimes")}"],
            "type": "array",
            "metadata": {
                "description": "Times in day when backup should be triggered. e.g. 01:00, 13:00. This will be used in LTR too for daily, weekly, monthly and yearly backup."
            }
        },
        "timeZone": {
            "defaultValue": "${lookup(var.backup_policies[count.index], "timeZone")}",
            "type": "string",
            "metadata": {
                "description": "Any Valid timezone, for example:UTC, Pacific Standard Time. Refer: https://msdn.microsoft.com/en-us/library/gg154758.aspx"
            }
        },
        "dailyRetentionDurationCount": {
            "defaultValue": ${lookup(var.backup_policies[count.index], "dailyRetentionDurationCount")},
            "type": "int",
            "metadata": {
                "description": "Number of days you want to retain the backup"
            }
        },
        "daysOfTheWeek": {
            "defaultValue": ["Sunday"],
            "type": "array",
            "metadata": {
                "description": "Backup will run on array of Days like, Monday, Tuesday etc. Applies in Weekly retention only."
            }
        },   
        "weeklyRetentionDurationCount": {
            "defaultValue": ${lookup(var.backup_policies[count.index], "weeklyRetentionDurationCount")},
            "type": "int",
            "metadata": {
                "description": "Number of weeks you want to retain the backup"
            }
        },     
        "monthlyRetentionDurationCount": {
            "defaultValue": ${lookup(var.backup_policies[count.index], "monthlyRetentionDurationCount")},
            "type": "int",
            "metadata": {
                "description": "Number of months you want to retain the backup"
            }
        },
        "monthsOfYear": {
            "defaultValue": [null],
            "type": "array",
            "metadata": {
                "description": "Array of Months for Yearly Retention"
            }
        },
        "yearlyRetentionDurationCount": {
            "defaultValue": 0,
            "type": "int",
            "metadata": {
                "description": "Number of years you want to retain the backup"
            }
        }
    },
    "resources": [
      {
        "type": "Microsoft.RecoveryServices/vaults",
        "apiVersion": "2015-11-10",
        "name": "[parameters('vaultName')]",
        "location": "[resourceGroup().location]",
        "sku": {
          "name": "RS0",
          "tier": "Standard"
        },
        "properties": {
        }
      },
      {
        "apiVersion": "2016-06-01",
        "name": "[concat(parameters('vaultName'), '/', parameters('policyName'))]",
        "type": "Microsoft.RecoveryServices/vaults/backupPolicies",
        "dependsOn": [ "[concat('Microsoft.RecoveryServices/vaults/', parameters('vaultName'))]" ],
        "location": "[resourceGroup().location]",
        "properties": {
          "backupManagementType": "AzureIaasVM",
          "schedulePolicy": {
            "scheduleRunFrequency": "Daily",
            "scheduleRunDays": null,
            "scheduleRunTimes": "[parameters('scheduleRunTimes')]",
            "schedulePolicyType": "SimpleSchedulePolicy"
          },
          "retentionPolicy": {
            "dailySchedule": {
              "retentionTimes": "[parameters('scheduleRunTimes')]",
              "retentionDuration": {
                  "count": "[parameters('dailyRetentionDurationCount')]",
                  "durationType": "Days"
              }
            },
            "weeklySchedule": {
              "daysOfTheWeek": "[parameters('daysOfTheWeek')]",
              "retentionTimes": "[parameters('scheduleRunTimes')]",
              "retentionDuration": {
                "count": "[parameters('weeklyRetentionDurationCount')]",
                "durationType": "Weeks"
              }
            },
            "monthlySchedule": {
              "retentionScheduleFormatType": "Daily",
              "retentionScheduleDaily": {
                "daysOfTheMonth": [
                  {
                    "date": 1,
                    "isLast": false
                  }
                ]
              },
              "retentionScheduleWeekly": null,
              "retentionTimes": "[parameters('scheduleRunTimes')]",
              "retentionDuration": {
                "count": "[parameters('monthlyRetentionDurationCount')]",
                "durationType": "Months"
              }
            },
            "yearlySchedule": null,
            "retentionPolicyType": "LongTermRetentionPolicy"
          },
          "timeZone": "[parameters('timeZone')]"
        }
      }
],
  "outputs": {
    "vaultName": {
      "type": "string",
      "value": "[parameters('vaultName')]"
    }
  }
}
DEPLOY

  deployment_mode = "Incremental"
}

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

