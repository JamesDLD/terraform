#Variables initialization

#Common variables
app_name = "jdld"

env_name = "apps"

#Below tag variable is no more used as this data is now probed trhough the data source module "Get-AzureRmResourceGroup"
default_tags = {
  ENV = "sand1"
  APP = "JDLD"
  BUD = "FR_BXXXXX"
  CTC = "j.dumont@veebaze.com"
}

rg_apps_name = "apps-jdld-sand1-rg1"

rg_infr_name = "infr-jdld-noprd-rg1"

#Storage
sa_infr_name = "infrsand1vpcjdld1"

#Backup
bck_rsv_name = "infra-jdld-infr-rsv1"

#Network

apps_snets = [
  {
    name              = "frontend"
    cidr_block        = "198.18.2.224/28"
    nsg_id            = "0" #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "0" #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = "1" #Id of the vnet
    service_endpoints = ""  #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
  {
    name              = "backend"
    cidr_block        = "198.18.2.240/28"
    nsg_id            = "0" #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "0" #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = "1" #Id of the vnet
    service_endpoints = ""  #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]

apps_nsgs = [
  {
    suffix_name = "nic-all"

    rules = [
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
        source_port_ranges         = ""
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
        source_port_ranges         = ""
      },
    ]
  },
]

# Virtual Machines components : Load Balancer & Availability Set & Nic & VM
Lb_sku = "Standard" #"Basic" 

Lbs = [
  {
    suffix_name = "ssh"
    Id_Subnet   = "0" #Id of the Subnet
    static_ip   = "198.18.2.238"
  },
  {
    suffix_name = "gfs"
    Id_Subnet   = "1" #Id of the Subnet
    static_ip   = "198.18.2.254"
  },
  {
    suffix_name = "rds"
    Id_Subnet   = "1" #Id of the Subnet
    static_ip   = "198.18.2.253"
  },
]

LbRules = [
  {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "0"   #Id of the Load Balancer
    suffix_name       = "ssh" #MUST match the Lbs suffix_name
    lb_port           = "80"
    backend_port      = "80"
    probe_port        = "80"
    probe_protocol    = "Http"
    request_path      = "/"
    load_distribution = "Default"
  },
  {
    Id                = "2"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "0"   #Id of the Load Balancer
    suffix_name       = "ssh" #MUST match the Lbs suffix_name
    lb_port           = "22"
    backend_port      = "22"
    probe_port        = "22"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  },
  {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "1"   #Id of the Load Balancer
    suffix_name       = "gfs" #MUST match the Lbs suffix_name
    lb_port           = "22"
    backend_port      = "22"
    probe_port        = "22"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  },
  {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "2"   #Id of the Load Balancer
    suffix_name       = "rds" #MUST match the Lbs suffix_name
    lb_port           = "3389"
    backend_port      = "3389"
    probe_port        = "3389"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  },
]

Linux_Vms = [
  {
    suffix_name                   = "ssh"
    id                            = "1"                      #Id of the VM
    Id_Lb                         = "0"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777"                    #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777"                    #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "0"                      #Id of the Subnet
    zone                          = "1"                      #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "BackupPolicy-Schedule1" #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "198.18.2.229"
    enable_accelerated_networking = "false"
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
  },
  {
    suffix_name                   = "ssh"
    id                            = "2"                      #Id of the VM
    Id_Lb                         = "0"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777"                    #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777"                    #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "1"                      #Id of the Subnet
    zone                          = "2"                      #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "1"                      #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "BackupPolicy-Schedule1" #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "198.18.2.245"
    enable_accelerated_networking = "false"
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
  },
]

Linux_DataDisks = [
  {
    id                = "0"    #Id of the VM from the upper list
    suffix_name       = "ssh1" #MUST match the VM suffix_name + the id of the VM
    id_disk           = "1"    #Id of the disk
    zone              = "1"    #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to ""
    managed_disk_type = "Premium_LRS"
    lun               = "0"
    disk_size_gb      = "32"
    caching           = "ReadWrite"
  },
]

Linux_storage_image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "Latest"
}

Windows_Vms = [
  {
    suffix_name                   = "rdg"
    id                            = "1"   #Id of the VM
    Id_Lb                         = "777" #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777" #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777" #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "0"   #Id of the Subnet
    zone                          = "1"   #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "1"   #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "777" #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "198.18.2.228"
    enable_accelerated_networking = "false"
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
  },
  {
    suffix_name                   = "rdg"
    id                            = "2"   #Id of the VM
    Id_Lb                         = "777" #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777" #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777" #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "1"   #Id of the Subnet
    zone                          = "2"   #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "1"   #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "777" #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "198.18.2.244"
    enable_accelerated_networking = "false"
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
  },
]

Windows_DataDisks = []

Windows_storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2019-Datacenter"
  version   = "Latest"
}

/*
Sample
Windows_DataDisks = [
  {
    id                = "0"           #Id of the VM from the upper list
    suffix_name       = "rdg1"        #MUST match the VM suffix_name + the id of the VM
    id_disk           = "1"           #Id of the disk
    zone              = "1"           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to ""
    managed_disk_type = "Premium_LRS"
    lun               = "0"
    disk_size_gb      = "32"
    caching           = "ReadWrite"
  },
]
*/
#VM Scale Set
Linux_Ss_Vms = [
  {
    suffix_name         = "gfs"
    id                  = "1" #Id of the VM
    Id_Lb               = "1" #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet           = "1" #Id of the Subnet
    Id_Nsg              = "1" #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    upgrade_policy_mode = "Manual"
    sku_name            = "Standard_DS1_v2"
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
    suffix_name         = "rds" #Windows computer name prefix cannot be more than 9 characters long
    id                  = "1"   #Id of the VM
    Id_Lb               = "2"   #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet           = "1"   #Id of the Subnet
    Id_Nsg              = "1"   #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    upgrade_policy_mode = "Manual"
    sku_name            = "Standard_DS1_v2"
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
