# Random string length
variable "random_string_length" {
  default = 4
}

# Location
variable "location" {
  default = "southeastasia"  
}

# Resource groups
variable "gcci_resource_groups" {
  default = {
    gcci_vnets_rg = {
      name = "gcci-platform"
    }

    gcci_law_rg = {
      name = "gcci-agency-law"
    }    
  }
}

# Virtual networks
variable "gcci_virtual_networks" {
  default = {

    gcci_ingress_vnet = {
      rg_key        = "gcci_vnets_rg"
      name          = "gcci-vnet-ingress"
      address_space = ["172.17.0.0/24"]
      tags          = {}
    } 

    gcci_egress_vnet = {
      rg_key        = "gcci_vnets_rg"
      name          = "gcci-vnet-egress"
      address_space = ["172.17.1.0/24"]
      tags          = {}
    }     

    gcci_internet_vnet = {
      rg_key        = "gcci_vnets_rg"
      name          = "gcci-vnet-internet"
      address_space = ["172.16.0.0/20"]
      tags          = {}
    }

    gcci_mgmt_vnet = {
      rg_key        = "gcci_vnets_rg"
      name          = "gcci-vnet-management"
      address_space = ["100.64.0.0/22"]
      tags          = {}
    }

    gcci_devops_vnet = {
      rg_key        = "gcci_vnets_rg"
      name          = "gcci-vnet-devops"
      address_space = ["100.65.0.0/20"]
      tags          = {}
    }

   

  }
}

# Virtual network peerings - not working
variable "gcci_vnet_peers" {
  default = {

    ingress_internet_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_ingress_vnet"
      remote_vnet_key = "gcci_internet_vnet"
      name            = "gcci-ingress-inter-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"   
    }

    internet_ingress_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_internet_vnet"
      remote_vnet_key = "gcci_ingress_vnet"
      name            = "gcci-inter-ingress-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"   
    }    

    mgmt_internet_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_mgmt_vnet"
      remote_vnet_key = "gcci_internet_vnet"
      name            = "gcci-mgmt-inter-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    internet_mgmt_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_internet_vnet"
      remote_vnet_key = "gcci_mgmt_vnet"
      name            = "gcci-inter-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    mgmt_devops_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_mgmt_vnet"
      remote_vnet_key = "gcci_devops_vnet"
      name            = "gcci-mgmt-devops-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    devops_mgmt_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_devops_vnet"
      remote_vnet_key = "gcci_mgmt_vnet"
      name            = "gcci-devops-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    mgmt_ingress_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_mgmt_vnet"
      remote_vnet_key = "gcci_ingress_vnet"
      name            = "gcci-mgmt-ingress-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }  

    ingress_mgmt_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_ingress_vnet"
      remote_vnet_key = "gcci_mgmt_vnet"
      name            = "gcci-ingress-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    } 

    devops_inter_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_devops_vnet"
      remote_vnet_key = "gcci_internet_vnet"
      name            = "gcci-devops-inter-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    } 

    inter_devops_vnet_peer = {
      rg_key          = "gcci_vnets_rg"
      vnet_key        = "gcci_internet_vnet"
      remote_vnet_key = "gcci_devops_vnet"
      name            = "gcci-inter-devops-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    } 
  }
  type = any
}

# Log Analytics Workspaces
variable "gcci_log_analytics_workspaces" {
  default = {
    gcci_law = {
      name = "gcci-law-central-logs"
      rg_key = "gcci_law_rg" 
      tags          = {}           
    }
   
  }
}
