variable "ass_scopes" {
  description = "Role definition Ids"
  type        = list(string)
}

variable "ass_role_definition_ids" {
  description = "Scope where the role definition Ids will be applied to"
  type        = list(string)
}

variable "ass_principal_id" {
  description = "Azure AD Object ID of the Service Principal to who you want to assign the role"
}

variable "ass_countRoleAssignment" {
  description = "Count of role you have"
}

