resource "azurerm_template_deployment" "backup_vault" {
  name                = "${var.rsv_name}-DEP"
  resource_group_name = "${var.rsv_resource_group_name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vaultName": {
            "defaultValue": "${var.rsv_name}",
            "type": "string",
            "metadata": {
                "description": "Name of the Vault"
            }
        },
        "skuTier": {
            "type": "string",
            "defaultValue": "Standard",
            "allowedValues": [
                "Standard"
            ],
            "metadata": {
                "description": "SKU tier for the vault"
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.RecoveryServices/vaults",
            "apiVersion": "2016-06-01",
            "name": "[parameters('vaultName')]",
            "location": "[resourceGroup().location]",
            "sku": {
                "name": "RS0",
                "tier": "[parameters('skuTier')]"
            },
            "properties": {
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

resource "azurerm_template_deployment" "backup_policies" {
  count               = "${length(var.rsv_backup_policies)}"
  name                = "${lookup(var.rsv_backup_policies[count.index], "Name")}-DEP"
  resource_group_name = "${var.rsv_resource_group_name}"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vaultName": {
            "defaultValue": "${azurerm_template_deployment.backup_vault.outputs["vaultName"]}",
            "type": "string",
            "metadata": {
                "description": "Name of the Recovery Services Vault"
            }
        },
        "policyName": {
            "defaultValue": "${lookup(var.rsv_backup_policies[count.index], "Name")}",
            "type": "string",
            "metadata": {
                "description": "Name of the Backup Policy"
            }
        },
        "scheduleRunTimes": {
            "defaultValue": ["${lookup(var.rsv_backup_policies[count.index], "scheduleRunTimes")}"],
            "type": "array",
            "metadata": {
                "description": "Times in day when backup should be triggered. e.g. 01:00, 13:00. This will be used in LTR too for daily, weekly, monthly and yearly backup."
            }
        },
        "timeZone": {
            "defaultValue": "${lookup(var.rsv_backup_policies[count.index], "timeZone")}",
            "type": "string",
            "metadata": {
                "description": "Any Valid timezone, for example:UTC, Pacific Standard Time. Refer: https://msdn.microsoft.com/en-us/library/gg154758.aspx"
            }
        },
        "dailyRetentionDurationCount": {
            "defaultValue": ${lookup(var.rsv_backup_policies[count.index], "dailyRetentionDurationCount")},
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
            "defaultValue": ${lookup(var.rsv_backup_policies[count.index], "weeklyRetentionDurationCount")},
            "type": "int",
            "metadata": {
                "description": "Number of weeks you want to retain the backup"
            }
        },     
        "monthlyRetentionDurationCount": {
            "defaultValue": ${lookup(var.rsv_backup_policies[count.index], "monthlyRetentionDurationCount")},
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
