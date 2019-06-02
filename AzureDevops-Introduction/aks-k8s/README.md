[Previous page >](../)

Create a Kubernetes cluster with Azure Kubernetes Service and Terraform
-----

The Terraform code available here has been inspired from those Microsoft guides:
1. [Create a Kubernetes cluster with Azure Kubernetes Service and Terraform](https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks)
2. [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster using the Azure CLI](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough)

With your Terraform template created, the first step is to initialize Terraform. 
This step ensures that Terraform has all the prerequisites to build your template in Azure.

```hcl

terraform init -backend-config="./variable/backend-jdld.tfvars" -backend-config="./secret/backend-jdld.json" -reconfigure

```

The terraform plan command is used to create an execution plan.
This step compares the requested resources to the state information saved by Terraform and then gives as an output the planned execution. Resources are not created in Azure.
```hcl

terraform plan -var-file="./variable/main-jdld.tfvars" -var-file="./secret/main-jdld.json"

```

If all is ok with the proposal you can now apply the configuration.
```hcl

terraform apply -var-file="./variable/main-jdld.tfvars" -var-file="./secret/main-jdld.json"

```

To destroy the associated resources.
```hcl

terraform destroy -var-file="./variable/main-jdld.tfvars" -var-file="./secret/main-jdld.json"

```