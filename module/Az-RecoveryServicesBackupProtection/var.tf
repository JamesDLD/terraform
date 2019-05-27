variable "subscription_id" {
  description="Azure subscription Id."
}

variable "bck_vms_resource_group_names" {
  description="VMs resource group names list."
  type = list(string)
}

variable "bck_vms_names" {
  description="VMs names list."
  type = list(string)
}

variable "bck_vms" {
  description="VMs object list indicating the bakcup policy name."
  type = list(object({
    BackupPolicyName              = string             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
  }))
}

variable "bck_rsv_name" {
  description="Recovery services vault name."
  type=string
}

variable "bck_rsv_resource_group_name" {
  description="Recovery services vault resource group name."
  type=string
}