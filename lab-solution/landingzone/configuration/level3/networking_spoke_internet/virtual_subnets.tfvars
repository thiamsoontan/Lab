
virtual_subnets = {

  # internet zone
  web_internet_subnet = {
    name    = "web-internet"
    cidr    = ["172.16.0.0/24"]
    nsg_key = "web_nsg"
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    enforce_private_link_endpoint_network_policies = "true"    
    vnet = {
      id = "/subscriptions/<subscription id>/resourceGroups/gcci-rg-agency-vnets/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet"
    }
  }  
  app_internet_subnet = {
    name    = "app-internet"
    cidr    = ["172.16.1.0/24"]
    nsg_key = "app_nsg"
    enforce_private_link_endpoint_network_policies = "true"    
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    vnet = {
      id = "/subscriptions/<subscription id>/resourceGroups/gcci-rg-agency-vnets/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet"
    }    
  }  
  db_internet_subnet = {
    name    = "db-internet"
    cidr    = ["172.16.2.0/24"]
    nsg_key = "db_nsg"
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    enforce_private_link_endpoint_network_policies = "true"   
    vnet = {
      id = "/subscriptions/<subscription id>/resourceGroups/gcci-rg-agency-vnets/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet"
    }
  }  
  it_internet_subnet = {
    name    = "it-internet"
    cidr    = ["172.16.3.0/24"]
    nsg_key = "it_nsg"
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    enforce_private_link_endpoint_network_policies = "true"    
    vnet = {
      id = "/subscriptions/<subscription id>/resourceGroups/gcci-rg-agency-vnets/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet"
    }
  }  
  gut_internet_subnet = {
    name    = "gut-internet"
    cidr    = ["172.16.4.0/24"]
    nsg_key = "gut_nsg"
    service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]
    enforce_private_link_endpoint_network_policies = "true"    
    vnet = {
      id = "/subscriptions/<subscription id>/resourceGroups/gcci-rg-agency-vnets/providers/Microsoft.Network/virtualNetworks/gcci-vnet-internet"
    }  
  }  

}
