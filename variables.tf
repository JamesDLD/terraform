#Variables declaration

#Authentication
variable "subscription_id" {}

variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "app_name" {}
variable "env_name" {}
variable "location" {}

variable "default_tags" {
  type = "map"
}

#Common
variable "sa_account_replication_type" {}

variable "sa_account_tier" {}
variable "rg_apps_name" {}
variable "sa_apps_name" {}
variable "rg_infr_name" {}
variable "sa_infr_name" {}

#Backup 
variable "backup_policies" {
  type = "list"
}

#Vnet & Subnet & Network Security group
variable "vnet_apps_address_space" {}

variable "apps_snets" {
  type = "list"
}

variable "default_routes" {
  type = "list"
}

variable "subnet_nsgrules" {
  type = "list"
}

#Load Balancers & Availability Set & Virtual Machines
variable "Lb_sku" {}

variable "Lbs" {
  type = "list"
}

variable "LbRules" {
  type = "list"
}

variable "Availabilitysets" {
  type = "list"
}

variable "Linux_Vms" {
  type = "list"
}

variable "Windows_Vms" {
  type = "list"
}

variable "app_admin" {
  default = "admindigital"
}

variable "pass" {
  default = "Passw0rd!123"
}

variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMelxhig6IY80GykqTf0wkozE860GPkd7RU5231b2UEMVyj1BBiPwTYCbAzY/8xBNyz9VL5uzjM6+S9N+OpIZKAMITzU1IVGzo7DtucNwKkRZ6egq+kfFG2JiKs945XOB6xhfFbzoneBu++yEToOrNLHM9Eu5eFFS07Ow+I2YIrTPpfw/UZCNUGFZun2iwm9MkKSWrBR8+/kE54WOAbrGq9symayBvD1A3aHBJ3HPL/geIzNAWw4y6YYsaCWOht1pVMfxf+LSf42XKJ/T8HjO0Ea2lKq5Nmh5cv5aKm6nVprF/L6SlQ3dNSUYPprnDiDBlPBGaBvtz2Hj0sseiu0YH"
}
