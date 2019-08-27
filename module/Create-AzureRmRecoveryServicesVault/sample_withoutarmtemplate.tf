/*Var
recovery_services_vault = {
  rsv1 = {
    id     = "3"
    prefix = "infra"
    sku    = "Standard"
  }
}

recovery_services_protection_policy_vm = {
  pol1 = {
    rsv_key = "rsv1"
    name    = "BackupPolicy-Schedule1"
    backup = [
      {
        frequency = "Daily"
        time      = "23:00"
      },
    ]
    retention_daily = [
      {
        count = 10
      },
    ]
    retention_weekly = [
      {
        count    = 42
        weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
      },
    ]
    retention_monthly = [
      {
        count    = 7
        weekdays = ["Sunday", "Wednesday"]
        weeks    = ["First", "Last"]
      },
    ]

    retention_yearly = [
      {
        count    = 77
        weekdays = ["Sunday"]
        weeks    = ["Last"]
        months   = ["January"]
      },
    ]
  }
}
*/

/* Main
variable "recovery_services_vault" {
  description = "Recovery Services Vault, map with properties described here : https://www.terraform.io/docs/providers/azurerm/r/recovery_services_vault.html"
  type        = any
}
variable "recovery_services_protection_policy_vm" {
  description = "Recovery Services VM Protection Policy, map with properties described here : https://www.terraform.io/docs/providers/azurerm/r/recovery_services_protection_policy_vm.html"
  type        = any
}

resource "azurerm_recovery_services_vault" "Infr" {
  for_each            = var.recovery_services_vault
  name                = "${each.value["prefix"]}-${var.app_name}-${var.env_name}-rsv${each.value["id"]}"
  location            = data.azurerm_resource_group.Infr.location
  resource_group_name = data.azurerm_resource_group.Infr.name
  sku                 = lookup(each.value, "sku", "RS0")
  tags                = data.azurerm_resource_group.Infr.tags
}

resource "azurerm_recovery_services_protection_policy_vm" "Infr" {
  for_each            = var.recovery_services_protection_policy_vm
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.Infr.name
  timezone            = lookup(each.value, "timezone", "UTC")

  dynamic "backup" {
    for_each = lookup(each.value, "backup", null)
    content {
      frequency = lookup(backup.value, "frequency", null)
      time      = lookup(backup.value, "time", null)
    }
  }

  dynamic "retention_daily" {
    for_each = lookup(each.value, "retention_daily", null)
    content {
      count = lookup(retention_daily.value, "count", null)
    }
  }

  dynamic "retention_weekly" {
    for_each = lookup(each.value, "retention_weekly", null)
    content {
      count    = lookup(retention_weekly.value, "count", null)
      weekdays = lookup(retention_weekly.value, "weekdays", null)
    }
  }

  dynamic "retention_monthly" {
    for_each = lookup(each.value, "retention_monthly", null)
    content {
      count    = lookup(retention_monthly.value, "count", null)
      weekdays = lookup(retention_monthly.value, "weekdays", null)
      weeks    = lookup(retention_monthly.value, "weeks", null)
    }
  }

  dynamic "retention_yearly" {
    for_each = lookup(each.value, "retention_yearly", null)
    content {
      count    = lookup(retention_yearly.value, "count", null)
      weekdays = lookup(retention_yearly.value, "weekdays", null)
      weeks    = lookup(retention_yearly.value, "weeks", null)
      months   = lookup(retention_yearly.value, "months", null)
    }
  }

  /*
  This forces a destroy when adding a new vnet --> 
  virtual_network_name      = lookup(azurerm_recovery_services_vault.Infr, each.value["rsv_key"], null)["name"]

  Workaround is to perform an explicit depedency-->
  */
/*
  depends_on          = [azurerm_recovery_services_vault.Infr]
  recovery_vault_name = "${lookup(var.recovery_services_vault, each.value["rsv_key"], "wrong_rsv_key_in_rsvpol")["prefix"]}-${var.app_name}-${var.env_name}-rsv${lookup(var.recovery_services_vault, each.value["rsv_key"], "wrong_rsv_key_in_rsvpol")["id"]}"
}
*/
