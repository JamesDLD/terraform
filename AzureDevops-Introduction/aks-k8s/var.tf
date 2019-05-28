#Variables declaration

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "tenant_id" {
  description = "Azure tenant Id."
}

variable "client_id" {
  description = "Azure service principal application Id"
}

variable "client_secret" {
  description = "Azure service principal application Secret"
}

variable "rg_infr_name" {
  description = "Resource group name that will host our services"
}

variable log_analytics_workspace_name {
  description = "The log analytics workspace name must be unique"
}

variable log_analytics_workspace_sku {
  default     = "PerGB2018"
  description = "refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing "
}
