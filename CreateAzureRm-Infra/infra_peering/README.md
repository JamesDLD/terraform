[Previous page >](../)

Step 1 Bis : Virtual Network peering
-----

I called this step with the suffix bis because I couldn't find a way to integrate it on the step 1, the issue is that the vnet peering module doesn't wait for the vnet to be created even with implicit depedencies.

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
