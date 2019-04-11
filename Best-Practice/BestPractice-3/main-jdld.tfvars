#Variables initialization

subnets = [
  {
    name              = "front"
    cidr_block        = "10.0.3.0/24"
    nsg_id            = "777"                                                                                                         #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "777"                                                                                                         #Id of the Route, set to 777 if there is no Routes
    vnet_name_id      = "0"                                                                                                           #Id of the vnet
    service_endpoints = "Microsoft.Storage Microsoft.Sql Microsoft.AzureActiveDirectory Microsoft.AzureCosmosDB Microsoft.ServiceBus" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]

Lbs = [
  {
    suffix_name = "internal"
    Id_Subnet   = "0"        #Id of the Subnet
    static_ip   = "10.0.3.4"
  },
]

Windows_Vms = [
  {
    suffix_name                   = "rdg"
    id                            = "1"               #Id of the VM
    Id_Lb                         = "0"               #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777"             #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777"             #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "0"               #Id of the Subnet
    zone                          = "1"               #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "777"             #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "777"             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "10.0.3.5"        #Set 777 to get dynamic IP
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
    enable_accelerated_networking = "false"
  },
  {
    suffix_name                   = "rdg"
    id                            = "2"               #Id of the VM
    Id_Lb                         = "0"               #Id of the Load Balancer, set to 777 if there is no Load Balancer
    Id_Lb_Public                  = "777"             #Id of the public Load Balancer, set to 777 if there is no public Load Balancer
    Id_Ip_Public                  = "777"             #Id of the public Ip, set to 777 if there is no public Ip
    Id_Subnet                     = "0"               #Id of the Subnet
    zone                          = "1"               #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    Id_Nsg                        = "777"             #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    BackupPolicyName              = "777"             #Set 777 to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    static_ip                     = "777"             #Set 777 to get dynamic IP
    vm_size                       = "Standard_DS1_v2"
    managed_disk_type             = "Premium_LRS"
    enable_accelerated_networking = "false"
  },
]

Windows_DataDisks = []

Windows_storage_image_reference = [
  {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "Latest"
  },
]
