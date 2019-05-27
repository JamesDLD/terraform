variable "rsv_name" {
  description="Recovery services vault name."
  type=string
}

variable "rsv_resource_group_name" {
  description="Recovery services vault rg name."
  type=string
}

variable "rsv_tags" {
  description="Recovery services vault tags."
  type = map(string)
}

variable "rsv_backup_policies" {
  description="Recovery services vault backup policies."
  type = list(object({
      Name                 = string
      scheduleRunFrequency = string
      scheduleRunDays      = string
      scheduleRunTimes     = string
      timeZone             = string
      dailyRetentionDurationCount   = number
      weeklyRetentionDurationCount  = number
      monthlyRetentionDurationCount = number
  }))
}