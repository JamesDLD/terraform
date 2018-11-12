

Best Practice 2 *UNDER CONSTRUCTION*
------------
In this article we will see how to set terraform, our provider and modules version, see [this article from terraform.io website to learn more about managing terraform version](https://www.terraform.io/docs/configuration/terraform.html) for more information.

In this article we will perform the following action  : 
1. Create a Load balancer
2. Create a Windows VM and attach it's NIC as backend of the upper load balancer


### Prerequisite
-----

| Item | Description |
| ------------- | ------------- |
| Azure Subscription | An Azure subscription id |
| Resource Group | An Azure resource group is available |
| Storage Account | An Azure storage account is available and is located in the upper resource group, it contains a container named `tfstate` |
| Service Principal | An Azure service principal is available and has the `owner` privilege on the upper resource group |
| Terraform file | Clone this repository and fill in the following files with the upper prerequisite items : <br> Variable used for the Terraform `init` : secret/backend-jdld.tf <br> Variable used for the Terraform `plan` and `apply` : ![main-jdld.tf](main-jdld.tf) & secret/main-jdld.tf |



What should we do?
------------
We will create the upper mentioned element using remote backend (see the previous article ![BestPractice-1](../BestPractice-1) for more information about remote backend).

The terraform excecutable file, the AzureRm provider and our modules version will be set as described in the following bracelet (also available in our ![main-jdld.tf](main-jdld.tf) terraform file).


Declare terraform required version 
```hcl
terraform {
  required_version = "0.11.8"

  backend "azurerm" {
    storage_account_name = "infrsand1vpodjdlddiagsa1"
    container_name       = "tfstate"
    key                  = "BestPractice-2.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}
```

Specify the AzureRm version 
```hcl
provider "azurerm" {
  version         = "1.15"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}
```

Specify on module version
```hcl

```



### 1. Usage
-----

    This step ensures that Terraform has all the prerequisites to build your template in Azure.

    ```hcl

    terraform init -backend-config="secret/backend-jdld.tfvars" -reconfigure

    ```
    The next step is to have Terraform review and validate the template. 
    This step compares the requested resources to the state information saved by Terraform and then outputs the planned execution. Resources are not created in Azure.
    ```hcl

    terraform plan -var-file="secret/main-jdld.tfvars" -var-file="main-jdld.tfvars"

    ```

    If all is ok with the proposal you can now apply the configuration.
    ```hcl

    terraform apply -var-file="secret/main-jdld.tfvars" -var-file="main-jdld.tfvars"

    ```

### 2. Analysis
-----

| Description | Screenshot |
| ------------- | ------------- |
| Our object have been created on Azure  | ![done](png/done.png) |
| Our remote backend has generated a Terraform tfstate with all our objects specifications | ![tfstate](png/tfstate.png) |


What shouldn't we do?
------------
We will now omit the backend specification, this will imply that we will no longer depend on a remote backend, in other word we will not be aware of any other deployment that have already be done by another person.

We will demonstrate here that remote backend encourage collaboration.

Let's remove the following bracelet : backend "azurerm" {}.
The top part of our ![main-jdld.tf](main-jdld.tf) script will look like the following : 
```hcl
terraform {
}
```

### 1. Usage
-----

    This step ensures that Terraform has all the prerequisites to build your template in Azure.

    ```hcl

    terraform init 

    ```
    > When the prompt `Do you want to copy existing state to the new backend?` appears enter `no` and press enter.


    You can now apply the configuration.
    ```hcl

    terraform apply -var-file="secret/main-jdld.tfvars"

    ```

### 2. Analysis
-----

| Description | Screenshot |
| ------------- | ------------- |
| Our object are still on Azure  | ![done](png/done.png) |
| The Terraform fails because for some resource like "azurerm_role_assignment" we can’t automatically <br> update our tfstate telling that the resource is already created as we wished. <br> Note that it wasn’t <br> the case for the resource "azurerm_virtual_network" | ![tfstate](png/error.png) |



See you!

Jamesdld