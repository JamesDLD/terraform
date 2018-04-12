/*
With your Terraform template created, the first step is to initialize Terraform. This step ensures that Terraform has all the prerequisites to build your template in Azure.
==> 
terraform init

The next step is to have Terraform review and validate the template. This step compares the requested resources to the state information saved by Terraform and then outputs the planned execution. Resources are not created in Azure.
==>
terraform plan -var-file="main-jdld-sand1.tfvars"
*/

# Provider

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Module

module "Create-AzureRmStorageAccount-Apps" {
  source                      = "./modules/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_apps_name}"
  sa_resource_group_name      = "${var.rg_apps_name}"
  sa_location                 = "${var.location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${var.default_tags}"
}

module "Create-AzureRmStorageAccount-Infr" {
  source                      = "./modules/Create-AzureRmStorageAccount"
  sa_name                     = "${var.sa_infr_name}"
  sa_resource_group_name      = "${var.rg_infr_name}"
  sa_location                 = "${var.location}"
  sa_account_replication_type = "${var.sa_account_replication_type}"
  sa_account_tier             = "${var.sa_account_tier}"
  sa_tags                     = "${var.default_tags}"
}

module "Create-AzureRmRecoveryServicesVault-Apps" {
  source                  = "./modules/Create-AzureRmRecoveryServicesVault"
  rsv_name                = "apps-${var.app_name}-${var.env_name}-rsv1"
  rsv_resource_group_name = "${var.rg_apps_name}"
  rsv_tags                = "${var.default_tags}"
  rsv_backup_policies     = ["${var.backup_policies}"]
}
