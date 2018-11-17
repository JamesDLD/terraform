

Best Practice 4 **UNDER CONSTRUCTION**
------------
These are my recommandation concerning the usage of the `azurerm_template_deployment` Terraform resource :
1. Don't use the `azurerm_template_deployment` Terraform resource
2. If you don't have the choice because one Terraform resource doesn't exist 
  * Create a feature request [here on github](https://github.com/terraform-providers/terraform-provider-azurerm/issues/new/choose)
  * Use the `azurerm_template_deployment` Terraform resource (a demo will be shown in this article)
  
Terraform can only manage the deployment of the ARM Template - and not any resources which are created by it. It's highly recommended using the Native Resources where possible instead rather than an ARM Template (see [this article](https://www.terraform.io/docs/providers/azurerm/r/template_deployment.html from terraform.io website for more information).

In this article we will perform the following action with : 
1. Create a Standard Public Load Balancer with outbound rules


### Prerequisite
-----

| Item | Description |
| ------------- | ------------- |
| Azure Subscription | An Azure subscription id |
| Resource Group | An Azure resource group is available |
| Storage Account | An Azure storage account is available and is located in the upper resource group, it contains a container named `tfstate` |
| Service Principal | An Azure service principal is available and has the `owner` privilege on the upper resource group |
| Terraform file | Clone this repository and fill in the following files with the upper prerequisite items : <br> Variable used for the Terraform `init` : secret/backend-jdld.tfvars <br> Variable used for the Terraform `plan` and `apply` : [main.tf](main.tf) & [main-jdld.tfvars](main-jdld.tfvars) & secret/main-jdld.tfvars |



What should we do?
------------
We will create the upper mentioned element using remote backend (see the previous article [BestPractice-1](../BestPractice-1) for more information about remote backend).

Review the code [main.tf](main.tf), as illustrated in the following bracket we are calling
```hcl
module 
```

https://github.com/JamesDLD/AzureRm-Template/tree/master/Create-AzureRmLoadBalancerOutboundRules

https://github.com/JamesDLD/terraform/tree/master/module/Add-AzureRmLoadBalancerOutboundRules


### 1. Usage
-----

This step ensures that Terraform has all the prerequisites to build your template in Azure.
```hcl
terraform init -backend-config="secret/backend-jdld.tfvars" -reconfigure
```

The Terraform plan command is used to create an execution plan.
This step compares the requested resources to the state information saved by Terraform and then gives as an output the planned execution. Resources are not created in Azure.
```hcl
terraform plan -var-file="secret/main-jdld.tfvars" -var-file="main-jdld.tfvars"
```

If all is ok with the proposal you can now apply the configuration with both methods (implicit and explicit) to track the impact.
```hcl
terraform apply -var-file="secret/main-jdld.tfvars" -var-file="main-jdld.tfvars"
```

We will now destroy what we have done with both methods (implicit and explicit) to track the impact.
```hcl
terraform destroy -var-file="secret/main-jdld.tfvars" -var-file="main-jdld.tfvars"
```

### 2. Analysis
-----

| Description | Screenshot |
| ------------- | ------------- |
| Our 2 network interfaces are linked to the Load Balancer | ![done](image/done.png) |
| When using implicit dependencies all is working like a charm | ![implicit](image/implicit.png) |
| When using explicit dependencies we receive error(s) because some resources doesn't wait for <br> other to be created (a workaround consists in using the variable `depend on` but this will still <br> cause error when you will proceed Terraform `destroy`) | ![explicit](image/explicit.png) |


See you!

Jamesdld
