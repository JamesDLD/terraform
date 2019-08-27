Repository inventory
------------

| Id  | Description | Build Status |
| ------------- | ------------- | ------------- |
| [Best-Practice](Best-Practice) | Share a list of best practices and tutoriels when using Terraform on Azure | [![Build Status](https://dev.azure.com/jamesdld23/vpc_lab/_apis/build/status/JamesDLD.terraform%20BP?branchName=master)](https://dev.azure.com/jamesdld23/vpc_lab/_build/latest?definitionId=5&branchName=master) |
| [Azure DevOps - Intro](AzureDevops-Introduction) | Share articles about CI/CD, Azure DevOps and Terraform on Azure. | [![Build Status](https://dev.azure.com/jamesdld23/vpc_lab/_apis/build/status/JamesDLD.terraform%20Introduction?branchName=master)](https://dev.azure.com/jamesdld23/vpc_lab/_build/latest?definitionId=9&branchName=master) |
| [CreateAzureRm-Infra](CreateAzureRm-Infra)  | Share Terraform script that reveal how to create a VPC in Azure and how application client can create their resources | [![Build Status](https://dev.azure.com/jamesdld23/vpc_lab/_apis/build/status/JamesDLD.terraform%20VPC?branchName=master)](https://dev.azure.com/jamesdld23/vpc_lab/_build/latest?definitionId=6&branchName=master) |


Azure and Terraform
------------
Simple and Powerful

HashiCorp Terraform enables you to safely and predictably create, change, and improve infrastructure. It is an open source tool that codifies APIs into declarative configuration files that can be shared among team members, treated as code, edited, reviewed, and versioned.

The following table is a quick comparison feedback between Terraform and Azure ARM template.

| Comparison  | Terraform | ARM Template |
| ------------- | ------------- | ------------- |
| Pro | Common language to deal with several providers (Azure including AzureRm and Azure AD, AWS, Nutanix, VMware, Docker,...)<br><br>Detect if a resource's parameter could be updated in place or if the resources need to be re created<br><br>Compliant test could be done easily to ensure that what you have deployed remains coherent<br><br>Facilitating CICD testing as the "plan" function tells you exactly what need to be done<br><br>If the Terraform resource doesn't exist we can execute ARM template from the Terraform resource "azurerm_template_deployment" | Microsoft Azure ownership<br><br>Variety of parameters types<br><br>Deployment log stored in the Azure Resource Group |
| Cons | Could not use secure object as parameter <br><br>New release might not be delivered as fast if it was the provider own tool <br><br>Authentication with service principal & certificate is not supported yet [#2471](https://github.com/terraform-providers/terraform-provider-azurerm/pull/2471) | AzureRm only<br><br>No option to preview what change should be done<br><br>The deployment mode "complete" permits to guarantee that your RG contains exactly what you want but the ARM template could be hard to read depending on the number of resources you put on it | 



About the [Terraform's modules](https://registry.terraform.io/modules/JamesDLD)
------------
On of the objective here is to share Terraform custom modules with the community with the following guidelines :
-	a module is used when we need to call a given number of resources several times and the same way, for exemple : when creating a VM we need nic, disks, backup, log monitoring, etc ..
-	a module doesn't contain any static values
-	a module is called using variables

