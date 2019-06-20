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

variable log_analytics_workspace {
  description = "The log analytics workspace"
  type        = any
  /* Following code is currently raising an error
  map(object({

    name=string #The log analytics workspace name must be unique
    sku=string  #Refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 

    solutions = list(object({
      name                  = string
      publisher             = string
      product               = string
    }))
  }))*/
}

variable "key_vault" {
  description = "The key vault"
  type        = map(string)
  # type = map(object({
  #   name    = string #The key vault name must be unique
  #   sku     = string
  # }))
}

variable "kubernetes_cluster" {
  description = "Kubernetes cluster with Azure Kubernetes Service"
  type        = any
}
