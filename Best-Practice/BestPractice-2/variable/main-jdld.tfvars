#Variables initialization

subnets = [
  {
    name              = "bp2-front-snet1"
    cidr_block        = "10.0.2.0/24"
    vnet_name_id      = "0" #Id of the vnet
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.ServiceBus"]
  },
]
