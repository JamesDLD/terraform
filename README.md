Objective
------------
Share terraform modules with the community with the following guidelines :
-	a module is dedicated to one action : create network interfaces, create an Azure recovery vault, ...
-	a module doesn't contain any static values
-	a module is called using variables

General Requirements
------------

-	[Terraform](https://www.terraform.io/downloads.html) 0.10.x
-	[AzureRM Terraform Provider](https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/README.md)
-	[AzureRM Terraform Provider - Authentication](https://www.terraform.io/docs/providers/azurerm/)

Improvment & Limitation
------------
-	Terraform authentication to AzureRM via Service Principal & certificate
-	Currently there is no Terraform resource for AzureRm recovery services, that's why I used the Terraform resource azurerm_template_deployment. [Improvment has been requested here for info](https://github.com/terraform-providers/terraform-provider-azurerm/issues/1007)
-	Couldn't find any option to set the BackupStorageRedundancy paremeter (LRS or GRS) in the RecoveryServices/vaults template, [Microsoft.RecoveryServices/vaults template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.recoveryservices/vaults)