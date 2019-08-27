#Variables initialization

subnets = {
  snet1 = {
    vnet_key          = "vnet1"                                #(Mandatory) 
    name              = "bp3-front-snet1"                      #(Mandatory) 
    address_prefix    = "10.0.3.0/24"                          #(Mandatory) 
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"] #(Optional) delete this line for no Service Endpoints
  }
}

Lbs = {
  lb1 = {
    id               = "1" #Id of the load balancer use as a suffix of the load balancer name
    suffix_name      = "internal"
    subnet_iteration = "0"        #Id of the Subnet
    static_ip        = "10.0.3.4" #(Optional) Set null to get dynamic IP or delete this line
  }
}

vms = {
  vm1 = {
    suffix_name           = "rds"          #(Mandatory) suffix of the vm
    id                    = "1"            #(Mandatory) Id of the VM
    static_ip             = "10.0.3.5"     #(Optional) Set null to get dynamic IP or delete this line
    internal_lb_iteration = "0"            #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    storage_data_disks    = []             #(Mandatory) For no data disks set []
    subnet_iteration      = "0"            #(Mandatory) Id of the Subnet
    zones                 = ["1"]          #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line
    vm_size               = "Standard_B2s" #(Mandatory) 
    managed_disk_type     = "Premium_LRS"  #(Mandatory) 
  }

  vm1 = {
    suffix_name           = "rds"          #(Mandatory) suffix of the vm
    id                    = "2"            #(Mandatory) Id of the VM
    static_ip             = "10.0.3.6"     #(Optional) Set null to get dynamic IP or delete this line
    internal_lb_iteration = "0"            #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    storage_data_disks    = []             #(Mandatory) For no data disks set []
    subnet_iteration      = "0"            #(Mandatory) Id of the Subnet
    zones                 = ["1"]          #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line
    vm_size               = "Standard_B2s" #(Mandatory) 
    managed_disk_type     = "Premium_LRS"  #(Mandatory) 
  }
}

windows_storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2016-Datacenter"
  version   = "Latest"
}
