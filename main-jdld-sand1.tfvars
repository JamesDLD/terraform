#Variables initialization
# Credentials azurerm
subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#Common variables
app_name = "jdld"

env_name = "sand1"

default_tags = {
  ENV = "sand1"
  APP = "JDLD"
  BUD = "FR_BXXXXX"
  CTC = "j.dumont@veebaze.com"
}

rg_apps_name = "apps-jdld-sand1-rg1"

rg_infr_name = "infr-jdld-noprd-rg1"

location = "northeurope"

#Storage account
sa_account_replication_type = "LRS"

sa_account_tier = "Standard"

sa_apps_name = "appssand1vpodjdlddiagsa1"

sa_infr_name = "infrsand1vpodjdlddiagsa1"

#Backup vault

backup_policies = [
  {
    Name                 = "BackupPolicy-Schedule1"
    scheduleRunFrequency = "Daily"
    scheduleRunDays      = "null"
    scheduleRunTimes     = "2017-01-26T20:00:00Z"
    timeZone             = "Romance Standard Time"

    dailyRetentionDurationCount   = "14"
    weeklyRetentionDurationCount  = "2"
    monthlyRetentionDurationCount = "2"
  },
]
