#Variables initialization

subnets = {
  snet1 = {
    vnet_key          = "vnet1"                                #(Mandatory) 
    name              = "bp2"                                  #(Mandatory) 
    address_prefix    = "198.18.1.0/26"                        #(Mandatory) 
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"] #(Optional) delete this line for no Service Endpoints
  }
}
