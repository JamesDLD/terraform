What's Terraform?
------------
Simple and Powerful

HashiCorp Terraform enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared amongst team members, treated as code, edited, reviewed, and versioned.


Objective
------------
Share Terraform custom modules with the community with the following guidelines :
-	a module is dedicated to one action : create network interfaces, create an Azure recovery vault, ...
-	a module doesn't contain any static values
-	a module is called using variables

General Requirements
------------

-	[Terraform](https://www.Terraform.io/downloads.html) 0.10.x
-	[AzureRM Terraform Provider](https://github.com/Terraform-providers/Terraform-provider-azurerm/blob/master/README.md)
-	[AzureRM Terraform Provider - Authentication](https://www.Terraform.io/docs/providers/azurerm/)

Golden rules
------------
-	 Always use Terraform implicit dependency, evict the use of the depends_on argument, [see Terraform dependencies article for more info](https://www.terraform.io/intro/getting-started/dependencies.html)
-	 Use remote backends to save your Terraform state, [see Terraform remote backends article for more info](https://www.terraform.io/intro/getting-started/remote.html)

Improvment & Limitation
------------
-	Terraform authentication to AzureRM via Service Principal & certificate
-	Currently there is no Terraform resource for AzureRm recovery services, that's why I used the Terraform resource azurerm_template_deployment. [Improvment has been requested here for info](https://github.com/Terraform-providers/Terraform-provider-azurerm/issues/1007)
-	Couldn't find any option to set the BackupStorageRedundancy paremeter (LRS or GRS) in the RecoveryServices/vaults template, [Microsoft.RecoveryServices/vaults template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.recoveryservices/vaults)