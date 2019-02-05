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
    route_suffix_name = "core"
  },
]

routes = [
  {
    name                   = "all_to_firewall"
    Id_rt                  = "0"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "198.18.1.4"
  },
]

vnets = [
  {
    vnet_suffix_name = "sec"
    address_spaces   = "198.18.1.0/24" #For multiple values add spaces between values
    dns_servers      = ""              #For multiple values add spaces between values
  },
  {
    vnet_suffix_name = "apps"
    address_spaces   = "198.18.2.0/24" #For multiple values add spaces between values
    dns_servers      = ""              #For multiple values add spaces between values
  },
]

snets = [
  {
    subnet_suffix_name = "AzureFirewallSubnet"
    cidr               = "198.18.1.0/26"
    Id_Nsg             = "777"                                                                                                                                               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    Id_route_table     = "777"                                                                                                                                               #Id of the Route table, set to 777 if there is no Route table
    Id_Vnet            = "0"                                                                                                                                                 #Id of the vnet
    service_endpoints  = "Microsoft.AzureActiveDirectory Microsoft.AzureCosmosDB Microsoft.EventHub Microsoft.KeyVault Microsoft.ServiceBus Microsoft.Sql Microsoft.Storage" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]

infra_nsgs = [
  {
    suffix_name = "snet-apps"
  },
]

infra_nsgrules = [
  {
    Id_Nsg                     = "0"                        #Id of the infra Network Security Group
    direction                  = "Inbound"
    suffix_name                = "ALL_to_frontend_tcp-3389"
    access                     = "Allow"
    priority                   = "2000"
    source_address_prefix      = "*"
    destination_address_prefix = "198.18.2.224/28"
    destination_port_range     = "3389"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    Id_Nsg                     = "0"                      #Id of the infra Network Security Group
    direction                  = "Inbound"
    suffix_name                = "ALL_to_frontend_tcp-22"
    access                     = "Allow"
    priority                   = "2001"
    source_address_prefix      = "*"
    destination_address_prefix = "198.18.2.224/28"
    destination_port_range     = "3389"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    Id_Nsg                     = "0"
    direction                  = "Inbound"
    suffix_name                = "ALL_to_frontend_Deny-All"
    access                     = "Deny"
    priority                   = "4095"
    source_address_prefix      = "*"
    destination_address_prefix = "198.18.2.224/28"
    destination_port_range     = "*"
    protocol                   = "*"
    source_port_range          = "*"
  },
]
