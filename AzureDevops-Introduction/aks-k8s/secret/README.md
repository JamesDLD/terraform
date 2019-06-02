Folder's golden rule
------------
-	Store secrets
-	File containing password are ignored by any git push


Secret files
------------
-	backend-jdld.json : stores the credential to write Terraform backend files
    - Content sample ==>
    ```json
        {
            "tenant_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "subscription_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_secret": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        }
    ```
-	main-jdld.json : stores the credential to write in Infra and Apps Resource groups and store the VM credentials
    - Content sample ==>
    ```json
        {
            "tenant_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "subscription_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_secret": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        }
    ```