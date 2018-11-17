Folder's golden rule
------------
-	Store secrets
-	File containing password are ignored by any git push


Secret files
------------
-	backend-jdld.tfvars : stores the credential to write Terraform backend files
    - Content sample ==>
```hcl
arm_subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
arm_client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
arm_client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
arm_tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

```
-	main-jdld.tfvars : stores the credential to write in Infra and Apps Resource groups and store the VM credentials
    - Content sample ==>
```hcl
subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#VM Credential
app_admin = "James"
pass = "Password0"
```