#Variables initialization

subnets = [
  {
    subnet_suffix_name = "front"
    cidr               = "10.0.2.0/24"
    Id_Nsg             = "777"                                                                                                         #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    Id_route_table     = "777"                                                                                                         #Id of the Route, set to 777 if there is no Routes
    Id_Vnet            = "0"                                                                                                           #Id of the vnet
    service_endpoints  = "Microsoft.Storage Microsoft.Sql Microsoft.AzureActiveDirectory Microsoft.AzureCosmosDB Microsoft.ServiceBus" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]
