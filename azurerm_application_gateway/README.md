[Previous page >](../)

Content
------------

Tutoriel on [medium.com](https://medium.com/faun/build-an-azure-application-gateway-with-terraform-8264fbd5fa42/?WT.mc_id=AZ-MVP-5003548) on how to build an Azure Application Gateway with:
- A Monitoring Dashboard hosted on a [Log Analytics Workspace](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/azure-networking-analytics?WT.mc_id=AZ-MVP-5003548).
- A [Key Vault](https://docs.microsoft.com/en-us/azure/application-gateway/key-vault-certs?WT.mc_id=AZ-MVP-5003548) as a safeguard of our Web TLS/SSL certificates.


Learn how to Use Terraform to build an Azure Application Gateway with:
- a Monitoring Dashboard hosted on a Log Analytics Workspace,
- and a Key Vault as a safeguard of Web TLS/SSL certificates.
#Azure #ApplicationGateway #Terraform #KeyVault #LogMonitor

Authentication
------------
Currently we use Authentication through AZ CLI : https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html
```
az login
az account set --subscription="mvp-sub1"
```


Sample usage on Net
-----

This step ensures that Terraform has all the prerequisites to build your template in Azure.
```hcl

terraform init 

```

The terraform plan command is used to create an execution plan.
This step compares the requested resources to the state information saved by Terraform and then gives as an output the planned execution. Resources are not created in Azure.
```hcl
terraform plan 
```

If all is ok with the proposal you can now apply the configuration.
```hcl
terraform apply 
```
