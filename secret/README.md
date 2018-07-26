Folder's golden rule
------------
-	Store secrets
-	File containing password are ignored by any git push


Secret files
------------
-	backend-jdld-sand1.tfvars : stores the credential to write Terraform backend files
    - Content ==>
    ```hcl
    storage_account_name = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    arm_subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    arm_client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    arm_client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    arm_tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ```
-	main-jdld-sand1.tfvars : stores the credential to write in Infra and Apps Resource groups and store the VM credentials
    ```hcl
    subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    service_principals = [
    {
        Application_Name   = "sp_infra" #Subscription Owner & Read directory data on Windows Azure Active Directory
        Application_Id     = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        Application_Secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        Application_object_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" #To get this param : $(Get-AzureRmADServicePrincipal -DisplayName $Application_Name).Id
    },
    {
        Application_Name   = "sp_apps"  #No Privileges needed, will be set by the script 
        Application_Id     = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        Application_Secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        Application_object_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" #To get this param : $(Get-AzureRmADServicePrincipal -DisplayName $Application_Name).Id
    },
    ]
    tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    #VM Credential and public key certificate
    app_admin = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    pass = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    ssh_key = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    #Key Vault
    key_vaults = [
    {
        suffix_name            = "sci"
        policy1_tenant_id      = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        policy1_object_id      = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        policy1_application_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    },
    ]
    ```