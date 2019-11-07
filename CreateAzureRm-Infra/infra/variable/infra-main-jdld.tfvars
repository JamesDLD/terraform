#Variables initialization

#Common variables
app_name = "jdld"

env_name = "infr"

#Below tag variable is no more used as this data is now probed trhough the data source module "Get-AzureRmResourceGroup"
default_tags = {
  ENV = "sand1"
  APP = "JDLD"
  BUD = "FR_BXXXXX"
  CTC = "j.dumont@veebaze.com"
}

rg_apps_name = "apps-jdld-sand1-rg1"

rg_infr_name = "infr-jdld-noprd-rg1"

#Policies
policies = [
  {
    suffix_name = "enforce-nsg-on-subnet" #Used to name the policy and to call json template files located into the module's folder
    policy_type = "Custom"
    mode        = "All"
  },
  {
    suffix_name = "enforce-udr-on-subnet" #Used to name the policy and to call json template files located into the module's folder
    policy_type = "Custom"
    mode        = "All"
  },
]

#Custom roles
roles = [
  {
    suffix_name = "apps-contributor"
    actions     = "*"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
  {
    suffix_name = "apps-write-subnet"
    actions     = "Microsoft.Network/virtualNetworks/subnets/Write Microsoft.Network/virtualNetworks/subnets/read Microsoft.Network/virtualNetworks/subnets/delete Microsoft.Network/virtualNetworks/subnets/join/action"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
  {
    suffix_name = "apps-join-infra-routeTable"
    actions     = "Microsoft.Network/routeTables/join/action"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
  {
    suffix_name = "apps-join-infra-nsg"
    actions     = "Microsoft.Network/networkSecurityGroups/join/action"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
  {
    suffix_name = "apps-armdeploy-infra"
    actions     = "Microsoft.Resources/deployments/*"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
  {
    suffix_name = "apps-enrollbackup-infra"
    actions     = "Microsoft.RecoveryServices/*"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
  {
    suffix_name = "apps-manage-infra-sa"
    actions     = "Microsoft.Storage/storageAccounts/*"
    not_actions = "Microsoft.Authorization/*/Delete Microsoft.Authorization/*/Write Microsoft.Authorization/elevateAccess/Action"
  },
]

#Storage

sa_infr_name = "infrasdbx1vpcjdld1"

#Backup 
backup_policies = [
  {
    Name                 = "BackupPolicy-Schedule1"
    scheduleRunFrequency = "Daily"
    scheduleRunDays      = "null"
    scheduleRunTimes     = "2017-01-26T20:00:00Z"
    timeZone             = "Romance Standard Time"

    dailyRetentionDurationCount   = "14"
    weeklyRetentionDurationCount  = "2"
    monthlyRetentionDurationCount = "2"
  },
]

#Key vault
kv_sku = "standard"

#Vnet & Route & Subnet & Network Security group & Application Security group

vnets = {
  sec1 = {
    id            = "1"
    prefix        = "sec"
    address_space = ["10.0.1.0/24"]
  }

  apps1 = {
    id            = "1"
    prefix        = "apps"
    address_space = ["10.0.2.0/24"]
  }
}

snets = {
  AzureFirewall1 = {
    vnet_key       = "sec1"                #(Mandatory) 
    name           = "AzureFirewallSubnet" #(Mandatory) 
    address_prefix = "10.0.1.0/26"         #Memo, Az Fw subnet minimu size : https://docs.microsoft.com/fr-fr/azure/firewall/firewall-faq#why-does-azure-firewall-need-a-26-subnet-size                                                                                                                                                    #(Mandatory) 
    service_endpoints = ["Microsoft.AzureActiveDirectory",
      "Microsoft.AzureCosmosDB", "Microsoft.EventHub",
      "Microsoft.KeyVault", "Microsoft.ServiceBus",
    "Microsoft.Sql", "Microsoft.Storage"] #(Optional) delete this line for no Service Endpoints
  }

  ApplicationGatewatey1 = {
    vnet_key       = "sec1"         #(Mandatory) 
    name           = "AppGw1"       #(Mandatory) 
    nsg_key        = "appgw_nsg1"   #(Optional) delete this line for no NSG
    address_prefix = "10.0.1.64/27" #Memo, subnet sizing for app gw : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview                                                                                                                                                     #(Mandatory) 
  }

  bastion_sec1 = {
    vnet_key       = "sec1"               #(Mandatory) 
    name           = "AzureBastionSubnet" #(Mandatory) 
    address_prefix = "10.0.1.224/27"      #Memo, subnet sizing for app gw : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview                                                                                                                                                     #(Mandatory) 
  }

  front1 = {
    vnet_key       = "apps1"       #(Mandatory) 
    name           = "front1"      #(Mandatory) 
    address_prefix = "10.0.2.0/26" #(Mandatory) 
    rt_key         = "rt1"         #(Optional) delete this line for no Route Table
  }

  back1 = {
    vnet_key       = "apps1"        #(Mandatory) 
    name           = "back1"        #(Mandatory) 
    address_prefix = "10.0.2.64/26" #(Mandatory) 
    rt_key         = "rt1"          #(Optional) delete this line for no Route Table
  }

  bastion_apps1 = {
    vnet_key       = "apps1"              #(Mandatory) 
    name           = "AzureBastionSubnet" #(Mandatory) 
    address_prefix = "10.0.2.224/27"      #Memo, subnet sizing for app gw : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview                                                                                                                                                     #(Mandatory) 
  }
}

vnets_to_peer = {

  vnets_to_peer1 = {
    vnet_key                     = "sec1"                 #(Mandatory) 
    remote_vnet_name             = "jdld-infr-apps-vnet1" #(Mandatory) 
    remote_vnet_rg_name          = "infr-jdld-noprd-rg1"  #(Mandatory) 
    allow_virtual_network_access = true                   #(Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false.
    allow_forwarded_traffic      = true                   #(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false.
    allow_gateway_transit        = false                  #(Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.
    use_remote_gateways          = false                  #(Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false.
  }

  vnets_to_peer2 = {
    vnet_key                     = "apps1"               #(Mandatory) 
    remote_vnet_name             = "jdld-infr-sec-vnet1" #(Mandatory) 
    remote_vnet_rg_name          = "infr-jdld-noprd-rg1" #(Mandatory) 
    allow_virtual_network_access = true                  #(Optional) Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false.
    allow_forwarded_traffic      = false                 #(Optional) Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false.
    allow_gateway_transit        = false                 #(Optional) Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network.
    use_remote_gateways          = false                 #(Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Defaults to false.
  }

}

# -
# - Network Security Group
# -
infra_nsgs = {
  appgw_nsg1 = {
    id = "1"
    security_rules = [
      {
        description                = "MS Reco : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview"
        direction                  = "Inbound"
        name                       = "AzureLoadBalancer_to_AppGw"
        access                     = "Allow"
        priority                   = "2000"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "*"
        destination_port_range     = "*"
        protocol                   = "*"
        source_port_range          = "*"
      },
      {
        description                = "MS Reco : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview"
        direction                  = "Inbound"
        name                       = "All_to_AppGw_Rangesv2"
        access                     = "Allow"
        priority                   = "2010"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "65200-65535"
        protocol                   = "*"
        source_port_range          = "*"
      },
      {
        direction                  = "Inbound"
        name                       = "All_to_AppGw_Http_Https"
        access                     = "Allow"
        priority                   = "2020"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_ranges    = ["80", "443"]
        protocol                   = "Tcp"
        source_port_range          = "*"
      },
      {
        description                = "MS Reco : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview"
        direction                  = "Inbound"
        name                       = "All_to_AppGw_any"
        access                     = "Deny"
        priority                   = "3000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "*"
        protocol                   = "*"
        source_port_range          = "*"
      },
      {
        description                = "MS Reco : https://docs.microsoft.com/fr-fr/azure/application-gateway/configuration-overview"
        direction                  = "Outbound"
        name                       = "ALL_to_ALL"
        access                     = "Allow"
        priority                   = "2100"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "*"
        protocol                   = "*"
        source_port_range          = "*"
      },
    ]
  }
}
# -
# - Route Table
# -
route_tables = {
  rt1 = {
    id = "1"
    routes = [
      /*
      {
        name                   = "all_to_firewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"
      },
      */
    ]
  }
}

# -
# - Azure Firewall
# -

az_firewall_rules = {
  application_rule_collections = {

    infra_common_services-appcol1 = {
      priority = 100
      action   = "Allow"
      rules = [
        {
          name             = "AllAzureTags-rule1"
          source_addresses = ["10.0.0.0/16"]
          fqdn_tags        = ["AppServiceEnvironment", "AzureBackup", "MicrosoftActiveProtectionService", "WindowsDiagnostics", "WindowsUpdate"]
          protocols        = []
        },
        {
          name             = "OsMgmt-rule1"
          source_addresses = ["10.0.0.0/16"]
          target_fqdns     = ["google.com", "debian.anexia.at", "debian.asis.io", "debian.balt.net", "debian.bhs.mirrors.ovh.net", "debian.blizoo.mk", "debian.bononia.it", "debian.c3sl.ufpr.br", "debian.carnet.hr", "debian.cc.lehigh.edu", "debian.charite.de", "debian.co.il", "debian.connesi.it", "debian.cs.binghamton.edu", "debian.csail.mit.edu", "debian.cse.msu.edu"]
          protocols = [
            {
              port = "443"
              type = "Https"
            },
            {
              port = "80"
              type = "Http"
            },
          ]
        },
      ]
    }

    sec_common_services-appcol1 = {
      priority = 200
      action   = "Allow"
      rules = [
        {
          name             = "sample-rule1"
          source_addresses = ["*"]
          target_fqdns     = ["*.mydomain.com"]
          protocols = [
            {
              port = "443"
              type = "Https"
            },
          ]
        },
      ]
    }

  }

  network_rule_collections = {

    infra_common_services-netcol1 = {
      priority = 100
      action   = "Allow"
      rules = [
        {
          name                  = "Dns-rule1"
          source_addresses      = ["10.0.0.0/16"]
          destination_ports     = ["53"]
          destination_addresses = ["8.8.8.8", ]
          protocols             = ["TCP", "UDP"]
        },
      ]
    }

  }

  nat_rule_collections = {

    infra_common_services-natcol1 = {
      priority = 100
      action   = "Dnat"
      rules = [
        {
          name               = "rdp-rule1"
          source_addresses   = ["*"]
          destination_ports  = ["3389"]
          protocols          = ["TCP"]
          translated_address = "10.0.2.228"
          translated_port    = "3389"
        },
      ]
    }

  }

}
