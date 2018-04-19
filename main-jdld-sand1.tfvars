#Variables initialization
#Authentication
subscription_id = "83acdf26-3269-4a8f-9b10-f472df718dc7"

client_id = "9b8c4f76-e337-4605-b973-47e963f32339"

client_secret = "a25a15fd-04d9-487a-9254-e87869518784"

tenant_id = "dd1c6376-71cf-495d-a78e-2694b30474b3"

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
    suffix_name                = "ALL_to_RBD_Allow-All"
    access                     = "Allow"
    priority                   = "4095"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    protocol                   = "*"
    source_port_range          = "*"
  },
]

/*
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
  */

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
