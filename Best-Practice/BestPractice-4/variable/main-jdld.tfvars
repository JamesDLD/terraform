#Variables initialization

lbs_public = [
  {
    suffix_name            = "outbound"
    sku                    = "Standard"
    allocatedOutboundPorts = "8"        #Number of SNAT ports, Load Balancer allocates SNAT ports in multiples of 8.
    idleTimeoutInMinutes   = "4"        #Outbound flow idle timeout. The parameter accepts a value from 4 to 66.
    enableTcpReset         = "false"    #Enable TCP Reset on idle timeout.
    protocol               = "Tcp"      #Transport protocol of the outbound rule.
  },
]
