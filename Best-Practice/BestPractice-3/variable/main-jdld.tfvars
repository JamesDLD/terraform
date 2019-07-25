#Variables initialization

subnets = [
  {
    name              = "bp3-front-snet1"
    cidr_block        = "10.0.3.0/24"
    vnet_name_id      = "0" #Id of the vnet
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ServiceBus"]
  },
]

Lbs = [
  {
    id               = "1" #Id of the load balancer use as a suffix of the load balancer name
    suffix_name      = "internal"
    subnet_iteration = "0" #Id of the Subnet
    static_ip        = "10.0.3.4"
  },
]

vms = [
  {
    suffix_name           = "rdg"             #(Mandatory) suffix of the vm
    id                    = "1"               #(Mandatory) Id of the VM
    static_ip             = "10.0.3.5"        #(Optional) Set null to get dynamic IP or delete this line
    internal_lb_iteration = "0"               #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    os_type               = "windows"         #(Mandatory) Support "linux" or "windows"
    storage_data_disks    = []                #(Mandatory) For no data disks set []
    subnet_iteration      = "0"               #(Mandatory) Id of the Subnet
    zones                 = ["1"]             #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size               = "Standard_DS1_v2" #(Mandatory) 
    managed_disk_type     = "Premium_LRS"     #(Mandatory) 
  },
  {
    suffix_name           = "rdg"             #(Mandatory) suffix of the vm
    id                    = "2"               #(Mandatory) Id of the VM
    static_ip             = "10.0.3.6"        #(Optional) Set null to get dynamic IP or delete this line
    internal_lb_iteration = "0"               #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    os_type               = "windows"         #(Mandatory) Support "linux" or "windows"
    storage_data_disks    = []                #(Mandatory) For no data disks set []
    subnet_iteration      = "0"               #(Mandatory) Id of the Subnet
    zones                 = ["2"]             #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size               = "Standard_DS1_v2" #(Mandatory) 
    managed_disk_type     = "Premium_LRS"     #(Mandatory) 
  },
]

windows_storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2016-Datacenter"
  version   = "Latest"
}
