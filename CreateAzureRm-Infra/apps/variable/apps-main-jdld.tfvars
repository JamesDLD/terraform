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
sa_infr_name = "infrasdbx1vpcjdld1"

#Backup
bck_rsv_name = "jdld-infr-rsv1"

#Network

apps_snets = [
  {
    vnet_name   = "jdld-infr-apps-vnet1"
    subnet_name = "front1"
  },
  {
    vnet_name   = "jdld-infr-apps-vnet1"
    subnet_name = "back1"
  },
]

apps_nsgs = {

  default_nsg1 = {
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
  }
}

# Virtual Machines components : Load Balancer & Availability Zone & Nic & VM
Lb_sku = "Standard" #"Basic"

Lbs = {

  lb1 = {
    id               = "1" #Id of the load balancer use as a suffix of the load balancer name
    suffix_name      = "ssh"
    subnet_iteration = "0" #Id of the Subnet
    static_ip        = "10.0.2.4"
  }

  lb2 = {
    id               = "1" #Id of the load balancer use as a suffix of the load balancer name
    suffix_name      = "gfs"
    subnet_iteration = "1" #Id of the Subnet
    static_ip        = "10.0.2.68"
  }

  lb3 = {
    id               = "1" #Id of the load balancer use as a suffix of the load balancer name
    suffix_name      = "rds"
    subnet_iteration = "1" #Id of the Subnet
    static_ip        = "10.0.2.69"
  }
}

LbRules = {

  lbrules1 = {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    lb_key            = "lb1" #Id of the Load Balancer
    suffix_name       = "ssh" #MUST match the Lbs suffix_name
    lb_port           = "80"
    backend_port      = "80"
    probe_port        = "80"
    probe_protocol    = "Http"
    request_path      = "/"
    load_distribution = "Default"
  }

  lbrules2 = {
    Id                = "2"   #Id of a the rule within the Load Balancer 
    lb_key            = "lb1" #Id of the Load Balancer
    suffix_name       = "ssh" #MUST match the Lbs suffix_name
    lb_port           = "22"
    backend_port      = "22"
    probe_port        = "22"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  }

  lbrules3 = {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    lb_key            = "lb2" #Id of the Load Balancer
    suffix_name       = "gfs" #MUST match the Lbs suffix_name
    lb_port           = "22"
    backend_port      = "22"
    probe_port        = "22"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  }

  lbrules4 = {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    lb_key            = "lb3" #Id of the Load Balancer
    suffix_name       = "rds" #MUST match the Lbs suffix_name
    lb_port           = "3389"
    backend_port      = "3389"
    probe_port        = "3389"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  }

}

windows_vms = {

  vm1 = {
    suffix_name              = "rdg"           #(Mandatory) suffix of the vm
    id                       = "1"             #(Mandatory) Id of the VM
    storage_data_disks       = []              #(Mandatory) For no data disks set []
    subnet_iteration         = "0"             #(Mandatory) Id of the Subnet
    security_group_iteration = "1"             #(Optional) Id of the Network Security Group
    static_ip                = "10.0.2.8"      #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["1"]           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size                  = "Standard_B2ms" #(Mandatory) 
    managed_disk_type        = "Premium_LRS"   #(Mandatory) 
  }

  vm2 = {
    suffix_name              = "rdg"           #(Mandatory) suffix of the vm
    id                       = "2"             #(Mandatory) Id of the VM
    storage_data_disks       = []              #(Mandatory) For no data disks set []
    subnet_iteration         = "1"             #(Mandatory) Id of the Subnet
    security_group_iteration = "1"             #(Optional) Id of the Network Security Group
    static_ip                = "10.0.2.72"     #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["2"]           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size                  = "Standard_B2ms" #(Mandatory) 
    managed_disk_type        = "Premium_LRS"   #(Mandatory) 
    #backup_policy_name       = "BackupPolicy-Schedule1" #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
  }

}

linux_vms = {

  vm1 = {
    suffix_name = "ssh" #(Mandatory) suffix of the vm
    id          = "1"   #(Mandatory) Id of the VM
    storage_data_disks = [
      {
        id                = "1" #Disk id
        lun               = "0"
        disk_size_gb      = "32"
        managed_disk_type = "Premium_LRS"
        caching           = "ReadWrite"
        create_option     = "Empty"
      },
    ]                                     #(Mandatory) For no data disks set []
    internal_lb_iteration    = "0"        #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    subnet_iteration         = "0"        #(Mandatory) Id of the Subnet
    security_group_iteration = "1"        #(Optional) Id of the Network Security Group
    static_ip                = "10.0.2.9" #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["1"]      #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    #backup_policy_name       = "BackupPolicy-Schedule1" #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    vm_size           = "Standard_B2ms" #(Mandatory) 
    managed_disk_type = "Premium_LRS"   #(Mandatory) 
  }

  vm2 = {
    suffix_name              = "ssh"           #(Mandatory) suffix of the vm
    id                       = "2"             #(Mandatory) Id of the VM
    storage_data_disks       = []              #(Mandatory) For no data disks set []
    internal_lb_iteration    = "0"             #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    subnet_iteration         = "1"             #(Mandatory) Id of the Subnet
    security_group_iteration = "1"             #(Optional) Id of the Network Security Group
    static_ip                = "10.0.2.73"     #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["2"]           #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size                  = "Standard_B2ms" #(Mandatory) 
    managed_disk_type        = "Premium_LRS"   #(Mandatory) 
  }

}

## Infra common services
#N/A
