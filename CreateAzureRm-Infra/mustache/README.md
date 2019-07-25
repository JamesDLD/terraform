Content
------------
Generate terraform ressources dynamically based on a variable and a template file.

Azure Firewall Rules - Model
------------
```
{
    "fw_rules": [
        {
            "network_rule_collection": [
                {
                    "network_rule_collection_name": "infra_common_services-ncol1",
                    "priority": 100,
                    "action": "Allow",
                    "rules": [
                        {
                            "name": "dns-rule1",
                            "source_addresses": "[\"10.0.2.0/24\"]",
                            "destination_ports": "[\"53\"]",
                            "destination_addresses": "[\"*\"]",
                            "protocols": "[\"TCP\", \"UDP\"]"
                        },
                        {
                            "name": "rbd-rule1",
                            "source_addresses": "[\"*\"]",
                            "destination_ports": "[\"3389\", \"22\"]",
                            "destination_addresses": "[\"10.0.2.230\", \"10.0.2.231\", \"10.0.2.228\"]",
                            "protocols": "[\"TCP\"]"
                        }
                    ]
                }
            ],
            "application_rule_collection": [
                {
                    "application_rule_collection_name": "infra_common_services-acol1",
                    "priority": 100,
                    "action": "Allow",
                    "rules_for_fqdn_tags": [
                        {
                            "name": "AzureTags-All-rule1",
                            "source_addresses": "[\"10.0.2.0/24\"]",
                            "fqdn_tags": "[\"MicrosoftActiveProtectionService\", \"WindowsDiagnostics\", \"WindowsUpdate\", \"AppServiceEnvironment\", \"AzureBackup\"]"
                        }
                    ],
                    "rules_for_target_fqdns": [
                        {
                            "name": "SecopsFqdn-rule1",
                            "source_addresses": "[\"10.0.2.0/24\"]",
                            "target_fqdns": "[\"*.google.com\", \"*.bing.com\"]",
                            "protocol": [
                                {
                                    "port": 443,
                                    "type": "Https"
                                },
                                {
                                    "port": 80,
                                    "type": "Http"
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    ]
}
```

NSG Rules - Usage
------------
```
#Variable init
template_file_location="./main_fw_rules.template"
variable_file_location="./var_fw_rules.json"
target_file_location="../../module/Az-Firewall/main_fw_rules.tf"

#Action
./main.sh $template_file_location $variable_file_location $target_file_location
```