#Variables initialization
#Azure Authentication & VM credentials
/*
Below secret are located in the "secret" folder which is ignored for any git sync, 
this associated file name is : main-jdld-sand1.tfvars

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

# VM Credential and public key certificate
app_admin = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
pass = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
ssh_key = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#DNS Custom API Credential
dns_fqdn_api = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
dns_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
dns_application_name = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
xpod_dns_zone_name = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
vpod_dns_zone_name = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#Key Vault
key_vaults = [
  {
    suffix_name            = "sci"
    policy1_tenant_id      = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    policy1_object_id      = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    policy1_application_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  },
]
*/

Dns_Vms_RecordsCount = "1"

Dns_Lbs_RecordsCount = "1"

Dns_Wan_RecordsCount = "1"

Dns_Wan_Records = [
  {
    hostname  = "portal-web-iis"
    static_ip = "169.69.32.132"
  },
  {
    hostname  = "portal-web-apa"
    static_ip = "169.69.32.132"
  },
]

#Common variables
app_name = "jdld"

env_name = "sand1"

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
sa_account_replication_type = "LRS"

sa_account_tier = "Standard"

sa_apps_name = "appssand1vpodjdlddiagsa2"

sa_infr_name = "infrsand1vpodjdlddiagsa1"

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
    name                   = "sec-via-routeurcusto"
    Id_rt                  = "0"
    address_prefix         = "192.168.2.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.5.5"
  },
]

vnets = [
  {
    vnet_suffix_name = "tech"
    address_spaces   = "198.18.1.0/24"           #For multiple values add spaces between values
    dns_servers      = "198.18.1.23 198.18.1.24" #For multiple values add spaces between values
  },
]

apps_snets = [
  {
    subnet_suffix_name = "frontend"
    cidr               = "198.18.1.224/28"
    Id_Nsg             = "0"               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    Id_route_table     = "0"               #Id of the Route table, set to 777 if there is no Route table
    Id_Vnet            = "0"               #Id of the vnet
  },
  {
    subnet_suffix_name = "backend"
    cidr               = "198.18.1.240/28"
    Id_Nsg             = "0"               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    Id_route_table     = "0"               #Id of the Route table, set to 777 if there is no Route table
    Id_Vnet            = "0"               #Id of the vnet
  },
]

infra_nsgs = [
  {
    suffix_name = "snet-frontend"
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
    destination_address_prefix = "198.18.1.224/28"
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
    destination_address_prefix = "198.18.1.224/28"
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
    destination_address_prefix = "198.18.1.224/28"
    destination_port_range     = "*"
    protocol                   = "*"
    source_port_range          = "*"
  },
]

apps_nsgs = [
  {
    suffix_name = "nic-all"
  },
]

apps_nsgrules = [
  {
    Id_Nsg                     = "0"                   #Id of the apps Network Security Group
    direction                  = "Inbound"
    suffix_name                = "ALL_to_NIC_tcp-3389"
    access                     = "Allow"
    priority                   = "2000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "3389"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    Id_Nsg                     = "0"
    direction                  = "Inbound"
    suffix_name                = "ALL_to_NIC_tcp-22"
    access                     = "Allow"
    priority                   = "2001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    Id_Nsg                     = "0"
    direction                  = "Inbound"
    suffix_name                = "ALL_to_NIC_Deny-All"
    access                     = "Deny"
    priority                   = "4096"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    protocol                   = "*"
    source_port_range          = "*"
  },
]

asgs = [
  {
    suffix_name = "ssh"
  },
  {
    suffix_name = "rdg"
  },
]

# Virtual Machines components : Load Balancer & Availability Set & Nic & VM
Lb_sku = "Basic" #"Standard" 

Lbs = [
  {
    suffix_name = "ssh"
    Id_Subnet   = "0"            #Id of the Subnet
    static_ip   = "198.18.1.238"
  },
  {
    suffix_name = "gfs"
    Id_Subnet   = "1"            #Id of the Subnet
    static_ip   = "198.18.1.254"
  },
  {
    suffix_name = "rds"
    Id_Subnet   = "1"            #Id of the Subnet
    static_ip   = "198.18.1.253"
  },
]

LbRules = [
  {
    Id             = "1"    #Id of a the rule within the Load Balancer 
    Id_Lb          = "0"    #Id of the Load Balancer
    suffix_name    = "ssh"  #MUST match the Lbs suffix_name
    lb_port        = "80"
    probe_protocol = "Http"
    request_path   = "/"
  },
  {
    Id             = "2"
    Id_Lb          = "0"
    suffix_name    = "ssh"
    lb_port        = "22"
    probe_protocol = "Tcp"
    request_path   = ""
  },
  {
    Id             = "1"
    Id_Lb          = "1"
    suffix_name    = "gfs"
    lb_port        = "22"
    probe_protocol = "Tcp"
    request_path   = ""
  },
  {
    Id             = "1"
    Id_Lb          = "2"
    suffix_name    = "rds"
    lb_port        = "3389"
    probe_protocol = "Tcp"
    request_path   = ""
  },
]

Availabilitysets = [
  {
    suffix_name = "rdg" #It must equals the Vm suffix_name
  },
]

Linux_Vms = [
  {
    suffix_name       = "ssh"
    id                = "1"                      #Id of the VM
    Id_Lb             = "0"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "0"                      #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "198.18.1.228"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "redhat"
    offer             = "RHEL"
    sku               = "7.3"
    lun               = "0"
    disk_size_gb      = "32"
  },
  {
    suffix_name       = "ssh"
    id                = "2"                      #Id of the VM
    Id_Lb             = "0"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "0"                      #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "198.18.1.229"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "redhat"
    offer             = "RHEL"
    sku               = "7.3"
    lun               = "0"
    disk_size_gb      = "32"
  },
]

Windows_Vms = [
  {
    suffix_name       = "rdg"
    id                = "1"                      #Id of the VM
    Id_Lb             = "777"                    #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "0"                      #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "198.18.1.230"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "MicrosoftWindowsServer"
    offer             = "WindowsServer"
    sku               = "2016-Datacenter"
    lun               = "0"
    disk_size_gb      = "32"
  },
  {
    suffix_name       = "rdg"
    id                = "2"                      #Id of the VM
    Id_Lb             = "777"                    #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "0"                      #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "198.18.1.231"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "MicrosoftWindowsServer"
    offer             = "WindowsServer"
    sku               = "2016-Datacenter"
    lun               = "0"
    disk_size_gb      = "32"
  },
]

#VM Scale Set
Linux_Ss_Vms = [
  {
    suffix_name         = "gfs"
    id                  = "1"               #Id of the VM
    Id_Lb               = "1"               #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet           = "1"               #Id of the Subnet
    Id_Nsg              = "1"               #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    upgrade_policy_mode = "Manual"
    sku_name            = "Standard_DS2_v2"
    sku_tier            = "Standard"
    sku_capacity        = 1
    publisher           = "OpenLogic"
    offer               = "CentOS"
    sku                 = "7.4"
    managed_disk_type   = "Premium_LRS"
    lun                 = "0"
    disk_size_gb        = "32"
  },
]

Windows_Ss_Vms = [
  {
    suffix_name         = "rds"                    #Windows computer name prefix cannot be more than 9 characters long
    id                  = "1"                      #Id of the VM
    Id_Lb               = "2"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet           = "1"                      #Id of the Subnet
    Id_Nsg              = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    upgrade_policy_mode = "Manual"
    sku_name            = "Standard_DS2_v2"
    sku_tier            = "Standard"
    sku_capacity        = 1
    publisher           = "MicrosoftWindowsServer"
    offer               = "WindowsServer"
    sku                 = "2016-Datacenter"
    managed_disk_type   = "Premium_LRS"
    lun                 = "0"
    disk_size_gb        = "32"
  },
]

## Infra common services
#Automation account
auto_sku = "Basic"
