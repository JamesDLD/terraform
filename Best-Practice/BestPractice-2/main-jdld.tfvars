#Variables initialization

subnets = [
  {
    name              = "bp2-front-snet1"
    cidr_block        = "10.0.2.0/24"
    nsg_id            = "777"                                                                                                         #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "777"                                                                                                         #Id of the Route, set to 777 if there is no Routes
    vnet_name_id      = "0"                                                                                                           #Id of the vnet
    service_endpoints = "Microsoft.Storage Microsoft.Sql Microsoft.AzureActiveDirectory Microsoft.AzureCosmosDB Microsoft.ServiceBus" #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]
