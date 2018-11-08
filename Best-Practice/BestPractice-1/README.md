Best Practice 1
------------
Use remote backend

What we should do
------------
Blalaba

![main](main-jdld.tfvars)

<h3>1. Usage</h3>
-----

With your Terraform template created, the first step is to initialize Terraform. 
This step ensures that Terraform has all the prerequisites to build your template in Azure.

```hcl

terraform init -backend-config="secret/backend-jdld.tfvars" -reconfigure

```
The next step is to have Terraform review and validate the template. 
This step compares the requested resources to the state information saved by Terraform and then outputs the planned execution. Resources are not created in Azure.
```hcl

terraform plan -var-file="secret/main-jdld.tfvars"

```

If all is ok with the proposal you can now apply the configuration.
```hcl

terraform apply -var-file="secret/main-jdld.tfvars"

```

<h3>2. Behavior</h3>
-----

What we shouln't do
------------
Blalaba
