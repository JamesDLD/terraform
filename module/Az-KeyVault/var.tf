variable "key_vaults" {
  description="List containing your key vaults."
  type = list(object({
    suffix_name    = string
    policy1_tenant_id =  string
    policy1_object_id              = string
    policy1_application_id              = string
  }))
}

variable "kv_prefix" {
  description="Key vault prefix name."
  type = string
}
variable "kv_suffix" {
  description="Key vault suffix name."
  type = string
}
variable "kv_location" {
  description="Key vault location."
  type = string
}
variable "kv_resource_group_name" {
  description="Key vault Resource group name."
  type = string
}
variable "kv_sku" {
  description="Key vault SKU."
  type = string
}
variable "kv_tenant_id" {
  description="Key vault Azure Tenant Id."
  type = string
}

variable "kv_tags" {
  description="Key vault tags."
  type = map(string)
}
