#Variables initialization

subnets = [
  {
    subnet_suffix_name = "front-demo"
    cidr               = "10.0.2.0/24"
    Id_Nsg             = "777"                                                                                                         #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    Id_route_table     = "777"                                                                                                         #Id of the Route, set to 777 if there is no Routes
    Id_Vnet            = "0"                                                                                                           #Id of the vnet
    service_endpoints  = "Microsoft.Storage Microsoft.Sql Microsoft.AzureActiveDirectory Microsoft.AzureCosmosDB Microsoft.ServiceBus" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]

Lbs = [
  {
    suffix_name = "internal"
    Id_Subnet   = "0"        #Id of the Subnet
    static_ip   = "10.0.2.4"
  },
]

Windows_Vms = [
  {
    suffix_name       = "rdg"
    id                = "1"                      #Id of the VM
    Id_Lb             = "0"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "777"                    #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "777"                    #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "10.0.2.5"
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
    Id_Lb             = "0"                      #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Subnet         = "0"                      #Id of the Subnet
    Id_Ava            = "777"                    #Id of the Availabilitysets, set to 777 if there is no Availabilitysets
    Id_Nsg            = "777"                    #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName  = "BackupPolicy-Schedule1"
    static_ip         = "10.0.2.6"
    vm_size           = "Standard_DS2_v2"
    managed_disk_type = "Premium_LRS"
    publisher         = "MicrosoftWindowsServer"
    offer             = "WindowsServer"
    sku               = "2016-Datacenter"
    lun               = "0"
    disk_size_gb      = "32"
  },
]
