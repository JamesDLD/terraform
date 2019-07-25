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

sa_infr_name = "infrsand1vpcjdld1"

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

route_tables = [
  {
    id = "1"
    routes = [
      {
        name                   = "all_to_firewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.1.4"
      },
    ]
  },
]

vnets = [
  {
    id            = "1"
    prefix        = "sec"
    address_space = ["10.0.1.0/24"]
    bastion       = false
  },
  {
    id            = "1"
    prefix        = "apps"
    address_space = ["10.0.2.0/24"]
    bastion       = false
  },
]

snets = [
  {
    virtual_network_iteration = "0" #Id of the vnet
    name                      = "AzureFirewallSubnet"
    address_prefix            = "10.0.1.0/26"
    service_endpoints         = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage"]
  },
  {
    virtual_network_iteration = "1" #Id of the vnet
    name                      = "frontend"
    address_prefix            = "10.0.2.224/28"
    security_group_iteration  = "0" #(Optional) delete this line for no NSG
    route_table_iteration     = "0" #(Optional) delete this line for no Route Table
  },
  {
    virtual_network_iteration = "1" #Id of the vnet
    name                      = "backend"
    address_prefix            = "10.0.2.240/28"
    security_group_iteration  = "0" #(Optional) delete this line for no NSG
    route_table_iteration     = "0" #(Optional) delete this line for no Route Table
  },
]

infra_nsgs = [
  {
    id = "1"
    security_rules = [
      {
        description                = "Demo1"
        direction                  = "Inbound"
        name                       = "ALL_to_NIC_tcp-3389"
        access                     = "Allow"
        priority                   = "2000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "3389"
        protocol                   = "tcp"
        source_port_range          = "*"
      },
      {
        direction                  = "Inbound"
        name                       = "ALL_to_NIC_tcp-80-443"
        access                     = "Allow"
        priority                   = "2001"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "80"
        protocol                   = "tcp"
        source_port_range          = "*"
      },
      {
        direction                  = "Outbound"
        name                       = "ALL_to_GoogleDns_udp-53"
        access                     = "Allow"
        priority                   = "2001"
        source_address_prefix      = "*"
        destination_address_prefix = "8.8.8.8"
        destination_port_range     = "53"
        protocol                   = "*"
        source_port_range          = "*"
      },
    ]
  },
]
