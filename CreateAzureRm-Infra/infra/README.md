[Previous page >](../)

Step 1 : Deliver the Infra
-----
The following sample will launch all the modules to show the reader how they are called.
My advice is that the reader pick up the module he wants and calls it how it's shown in the root "main.tf" file.

[Clone this repository](https://github.com/JamesDLD/terraform/tree/master/CreateAzureRm-Infra)

With your Terraform template created, the first step is to initialize Terraform. 
This step ensures that Terraform has all the prerequisites to build your template in Azure.

```hcl

terraform init -backend-config="infra-backend-jdld.tfvars" -backend-config="../secret/backend-jdld.tfvars" -reconfigure

```

The terraform plan command is used to create an execution plan.
This step compares the requested resources to the state information saved by Terraform and then gives as an output the planned execution. Resources are not created in Azure.
```hcl

terraform plan -var-file="infra-main-jdld.tfvars" -var-file="../secret/main-jdld.tfvars"

```

If all is ok with the proposal you can now apply the configuration.
```hcl

terraform apply -var-file="infra-main-jdld.tfvars" -var-file="../secret/main-jdld.tfvars"

```
