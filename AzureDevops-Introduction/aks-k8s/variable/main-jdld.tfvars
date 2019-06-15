#Variables initialization

###
# Core
###

rg_infr_name = "infr-jdld-noprd-rg1"

###
# Log & Certificate
###

log_analytics_workspace = {
  name = "demojdldloganwk1" #The log analytics workspace name must be unique
  sku  = "PerGB2018"        #Refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 

  solutions = [{
    name      = "ContainerInsights"
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }]
}

key_vault = {
  name = "demoazintroaksjdld" #The kay vault name must be unique
  sku  = "standard"
}

###
# AKS
###
kubernetes_cluster = {
  name       = "aks-demo-jdld"
  dns_prefix = "aksdemojdld" #Please see https://aka.ms/aks-naming-rules
}
