#Variables initialization
#Azure Authentication & VM credentials
subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

client_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

client_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

app_admin = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

pass = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

ssh_key = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#DNS Custom API Credential
dns_fqdn_api = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

dns_secret = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

dns_application_name = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

xpod_dns_zone_name = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

vpod_dns_zone_name = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

Dns_Vms_RecordsCount = "2"

Dns_Lbs_RecordsCount = "1"

Dns_Wan_RecordsCount = "2"

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

default_tags = {
  ENV = "sand1"
  APP = "JDLD"
  BUD = "FR_BXXXXX"
  CTC = "j.dumont@veebaze.com"
}

rg_apps_name = "apps-jdld-sand1-rg1"

rg_infr_name = "infr-jdld-noprd-rg1"

location = "northeurope"

#Storage
sa_account_replication_type = "LRS"

sa_account_tier = "Standard"

sa_apps_name = "appssand1vpodjdlddiagsa1"

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

key_vaults = [
  {
    suffix_name       = "sci"
    policy1_tenant_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    policy1_object_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  },
]

#Vnet & Subnet & Network Security group
vnet_apps_address_space = "10.0.3.0/24"

apps_snets = [
  {
    subnet_suffix_name = "rebond"
    cidr               = "10.0.3.0/28"
  },
]

default_routes = [
  {
    name                   = "sec-via-routeurcusto-rt1"
    address_prefix         = "192.168.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.5.5"
  },
]

subnet_nsgrules = [
  {
    subnet_suffix_name         = "rebond"
    suffix_name                = "ALL_to_RBD_tcp-3389"
    access                     = "Allow"
    priority                   = "2000"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0/28"
    destination_port_range     = "3389"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    subnet_suffix_name         = "rebond"
    suffix_name                = "ALL_to_RBD_tcp-22"
    access                     = "Allow"
    priority                   = "2001"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0/28"
    destination_port_range     = "22"
    protocol                   = "tcp"
    source_port_range          = "*"
  },
  {
    subnet_suffix_name         = "rebond"
    suffix_name                = "ALL_to_RBD_Deny-All"
    access                     = "Deny"
    priority                   = "4095"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0/28"
    destination_port_range     = "*"
    protocol                   = "*"
    source_port_range          = "*"
  },
]

# Virtual Machines components : Load Balancer & Availability Set & Nic & VM
Lb_sku = "Standard" #"Basic" 

Lbs = [
  {
    suffix_name = "bou"       #It must equals the Vm suffix_name
    Id_Subnet   = "0"         #Id of the Subnet
    static_ip   = "10.0.3.13"
  },
  {
    suffix_name = "rdg"       #It must equals the Vm suffix_name
    Id_Subnet   = "0"         #Id of the Subnet
    static_ip   = "10.0.3.14"
  },
]

LbRules = [
  {
    Id             = "1"    #Id of a the rule within the Load Balancer 
    Id_Lb          = "0"    #Id of the Load Balancer
    suffix_name    = "bou"  #It must equals the Lbs suffix_name
    lb_port        = "80"
    probe_protocol = "Http"
    request_path   = "/"
  },
  {
    Id             = "2"
    Id_Lb          = "0"
    suffix_name    = "bou"
    lb_port        = "22"
    probe_protocol = "Tcp"
    request_path   = ""
  },
  {
    Id             = "1"
    Id_Lb          = "1"
    suffix_name    = "rdg"
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
    suffix_name       = "bou"                    #If Availabilitysets it must equals the Availabilitysets suffix_name / If Load Balancer it must with the Lbs suffix_name
    id                = "1"                      #Id of the VM
    Id_BackupVault    = "0"                      #Id of the Backup Recovery Vault
    Id_Lb             = "0"                      #Id of the Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "777"                    #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "10.0.3.5"
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
    suffix_name       = "rdg"                    #If Availabilitysets it must equals the Availabilitysets suffix_name / If Load Balancer it must with the Lbs suffix_name
    id                = "1"                      #Id of the VM
    Id_BackupVault    = "0"                      #Id of the Backup Recovery Vault
    Id_Lb             = "1"                      #Id of the Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "0"                      #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "10.0.3.4"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "MicrosoftWindowsServer"
    offer             = "WindowsServer"
    sku               = "2016-Datacenter"
    lun               = "0"
    disk_size_gb      = "32"
  },
]
