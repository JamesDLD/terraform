[Previous page >](../)

Step 2 : Deliver an Apps environment
-----

With your Terraform template created, the first step is to initialize Terraform. 
This step ensures that Terraform has all the prerequisites to build your template in Azure.

```hcl

terraform init -backend-config="variable/apps-backend-jdld.tfvars" -backend-config="../secret/backend-jdld.json" -reconfigure

```

The terraform plan command is used to create an execution plan.
This step compares the requested resources to the state information saved by Terraform and then gives as an output the planned execution. Resources are not created in Azure.
```hcl

terraform plan -var-file="variable/apps-main-jdld.tfvars" -var-file="../secret/main-jdld.tfvars"

```

If all is ok with the proposal you can now apply the configuration.
```hcl

terraform apply -var-file="variable/apps-main-jdld.tfvars" -var-file="../secret/main-jdld.tfvars"

```

To destroy the associated resources.
```hcl

terraform destroy -var-file="apps-main-jdld.tfvars" -var-file="../secret/main-jdld.tfvars"

```