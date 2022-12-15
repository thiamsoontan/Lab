#
# Definition of the networking security groups
#
network_security_group_definition = {
  # This entry is applied to all subnets with no NSG defined
  empty_nsg = {
    version            = 1
    resource_group_key = "networking_spoke_re1"
    name               = "empty"
    nsg = []
  }

  web_nsg = {
    version            = 1
    resource_group_key = "networking_spoke_re1"
    name               = "web"    
    tags = { 
      purpose = "web tier network security group" 
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"         
    }      
    nsg = [

      # https://learn.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure
      # Network security groups (NSGs) are supported on Application Gateway. But there are some restrictions:
      # - You must allow incoming Internet traffic on TCP ports 65503-65534 for the Application Gateway v1 SKU, and TCP ports 65200-65535 for the v2 SKU with the destination subnet as Any and source as GatewayManager service tag. This port range is required for Azure infrastructure communication. These ports are protected (locked down) by Azure certificates. External entities, including the customers of those gateways, can't communicate on these endpoints.
      # - Outbound Internet connectivity can't be blocked. Default outbound rules in the NSG allow Internet connectivity. We recommend that you:
      #     Don't remove the default outbound rules.
      #     Don't create other outbound rules that deny any outbound connectivity.
      # - Traffic from the AzureLoadBalancer tag with the destination subnet as Any must be allowed.

      # do not change      
      # source Internet destination Any : source MUST be Internet and destination MUST be *
      {
        name                       = "Inbound-AGW-management"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "Internet" # MUST be Internet
        destination_address_prefix = "*" # MUST be *        
      }, 
      # do not change
      # Source AzureLoadBalancer destination Any
      {
        name                       = "Inbound-AzureLoadBalancer-management"
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "VirtualNetwork"
      },         
      # do not change
      # inbound https 443 management infra "100.64.0.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-HTTPS-management"
        priority                   = "120"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "100.64.0.0/24"
        destination_address_prefix = "172.16.0.0/24"
      }, 
      # do not change      
      # inbound http 80 management infra "100.64.0.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-HTTP-management"
        priority                   = "200"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "100.64.0.0/24"
        destination_address_prefix = "172.16.0.0/24"
      },   
      # do not change            
      # inbound ssh 22 management bastion "100.64.2.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-SSH-management"
        priority                   = "210"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.0.0/24"
      },    
    # end management inbound        
    # begin web inbound   
      # inbound https 443 ingress "172.17.0.0/24" > web "172.16.0.0/24"      
      {
        name                       = "Inbound-HTTPS-ingress"
        priority                   = "220"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.17.0.0/24"
        destination_address_prefix = "172.16.0.0/24"
      },
      # inbound http 80-82 ingress "172.17.0.0/24" > web "172.16.0.0/24"       
      {
        name                       = "Inbound-HTTP-ingress"
        priority                   = "230"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "172.17.0.0/24"
        destination_address_prefix = "172.16.0.0/24"
      }, 
      # inbound http 8080-8082 ingress "172.17.0.0/24" > web "172.16.0.0/24"       
      {
        name                       = "Inbound-HTTP-8080-ingress"
        priority                   = "240"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "8080-8082"
        source_address_prefix      = "172.17.0.0/24"
        destination_address_prefix = "172.16.0.0/24"
      },  
      # custom deny all Inbound
      {
        name                       = "Custom-Deny-All-Inbound"
        priority                   = "4000"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },       
    # end web inbound   

    # begin management outbound

      # do not change
      # outbound https 443 AzureMonitor"
      {
        name                       = "out-communication-allow-443-AzureMonitor"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "AzureMonitor"
      },
      # do not change
      # # outbound https 443 EventHub"
      # {
      #   name                       = "out-communication-allow-443-EventHub"
      #   priority                   = "110"
      #   direction                  = "Outbound"
      #   access                     = "Allow"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "443"
      #   source_address_prefix      = "172.16.0.0/24"
      #   destination_address_prefix = "EventHub"
      # },  
      # do not change
      # outbound https 443 AzureActiveDirectory"
      {
        name                       = "out-communication-allow-443-AzureActiveDirectory"
        priority                   = "120"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "AzureActiveDirectory"
      }, 
      # do not change
      # outbound https 443 Storage"
      {
        name                       = "out-communication-allow-443-Storage"
        priority                   = "130"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "Storage"
      },  
      # do not change
      # outbound https 443 AzureKeyVault.SouthEastAsia"
      {
        name                       = "out-communication-allow-443-AzureKeyVault.SouthEastAsia"
        priority                   = "140"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "AzureKeyVault.SouthEastAsia"
      }, 
      # do not change
      # outbound https 443 MicrosoftCloudAppSecurity"
      {
        name                       = "out-communication-allow-443-MicrosoftCloudAppSecurity"
        priority                   = "150"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "MicrosoftCloudAppSecurity"
      },                               
      # do not change
      # outbound https 443 web "172.16.0.0/24" > management infra "100.64.0.0/24"
      {
        name                       = "out-communication-allow-443-management"
        priority                   = "160"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "100.64.0.0/24"
      },
      
    # end management outbound   
    # begin web outbound
      # outbound https 443 web "172.16.0.0/24" > app "172.16.1.0/24"
      {
        name                       = "out-communication-allow-443-app"
        priority                   = "200"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      },
      # outbound http 8080 web "172.16.0.0/24" > app "172.16.1.0/24"
      {
        name                       = "out-communication-allow-8080-app"
        priority                   = "210"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      }, 
      # outbound http 80-82 web "172.16.0.0/24" > app "172.16.1.0/24"
      {
        name                       = "out-communication-allow-80-app"
        priority                   = "220"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      }, 
      # custom deny all outbound - only valid if private preview is enabled      
      # {
      #   name                       = "custom-deny-all-outbound"
      #   priority                   = "4000"
      #   direction                  = "Outbound"
      #   access                     = "Deny"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "*"
      #   source_address_prefix      = "*"
      #   destination_address_prefix = "*"
      # },           
      # end web outbound 
   
    ]
  }



  # AKS
  # The following FQDN / application rules are required:
  # Destination FQDN	          Port	Use
  # *.hcp.<location>.azmk8s.io	HTTPS:443	
  #   Required for Node <-> API server communication. Replace <location> with the region where your AKS cluster is deployed. This is required for clusters with konnectivity-agent enabled. Konnectivity also uses Application-Layer Protocol Negotiation (ALPN) to communicate between agent and server. Blocking or rewriting the ALPN extension will cause a failure. This is not required for private clusters.
  # mcr.microsoft.com	          HTTPS:443	
  #    Required to access images in Microsoft Container Registry (MCR). This registry contains first-party images/charts (for example, coreDNS, etc.). These images are required for the correct creation and functioning of the cluster, including scale and upgrade operations.
  # *.data.mcr.microsoft.com	  HTTPS:443	
  #    Required for MCR storage backed by the Azure content delivery network (CDN).
  # management.azure.com	      HTTPS:443	- AzureResourceManager
  #    Required for Kubernetes operations against the Azure API.
  # login.microsoftonline.com	  HTTPS:443	
  #    Required for Azure Active Directory authentication.
  # packages.microsoft.com	    HTTPS:443	
  #    This address is the Microsoft packages repository used for cached apt-get operations. Example packages include Moby, PowerShell, and Azure CLI.
  # acs-mirror.azureedge.net	  HTTPS:443	
  #    This address is for the repository required to download and install required binaries like kubenet and Azure CNI.

  # ** The only way is to use egress firewall now **
  # Restrict egress traffic using Azure firewall
  # Azure Firewall provides an Azure Kubernetes Service (AzureKubernetesService) FQDN Tag to simplify this configuration.

  app_nsg = {
    version            = 1
    resource_group_key = "networking_spoke_re1"
    name               = "app"   
    tags = { 
      purpose = "app tier network security group"
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"     
    }        
    nsg = [   
    # begin management inbound
  
      # do not change
      # inbound https 443 management infra "100.64.0.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-HTTPS-managemet"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "100.64.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      }, 
      # do not change      
      # inbound http 80 management infra "100.64.0.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-HTTP-managemet"
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "100.64.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      },   
      # do not change            
      # inbound ssh 22 management bastion "100.64.2.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-SSH-managemet"
        priority                   = "120"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.0.0/24"
      }, 
    # end management inbound                   
      # inbound https 443 web "172.16.0.0/24" > app "172.16.1.0/24"      
      {
        name                       = "Inbound-HTTPS-web"
        priority                   = "200"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      },
      # inbound http 80-82 web "172.16.0.0/24" > app "172.16.1.0/24"      
      {
        name                       = "Inbound-HTTP-web"
        priority                   = "210"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      }, 
      # inbound http 8080-8082 web "172.16.0.0/24" > app "172.16.1.0/24"  
      {
        name                       = "Inbound-HTTP-8080"
        priority                   = "220"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "8080-8082"
        source_address_prefix      = "172.16.0.0/24"
        destination_address_prefix = "172.16.1.0/24"
      }, 
      # custom deny all
      {
        name                       = "Custom-Deny-All-Inbound"
        priority                   = "4000"
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },                                       
 
    # begin management outbound

      # do not change
      # outbound https 443 AzureMonitor"
      {
        name                       = "out-communication-allow-443-AzureMonitor"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureMonitor"
      },
      # # do not change
      # # outbound https 443 EventHub"
      # {
      #   name                       = "out-communication-allow-443-EventHub"
      #   priority                   = "110"
      #   direction                  = "Outbound"
      #   access                     = "Allow"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "443"
      #   source_address_prefix      = "172.16.1.0/24"
      #   destination_address_prefix = "EventHub"
      # },  
      # do not change
      # outbound https 443 AzureActiveDirectory"
      {
        name                       = "out-communication-allow-443-AzureActiveDirectory"
        priority                   = "120"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureActiveDirectory"
      }, 
      # do not change
      # outbound https 443 Storage"
      {
        name                       = "out-communication-allow-443-Storage"
        priority                   = "130"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "Storage"
      },  
      # do not change
      # outbound https 443 AzureKeyVault.SouthEastAsia"
      {
        name                       = "out-communication-allow-443-AzureKeyVault.SouthEastAsia"
        priority                   = "140"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureKeyVault.SouthEastAsia"
      },   
      # do not change
      # outbound https 443 MicrosoftCloudAppSecurity"
      {
        name                       = "out-communication-allow-443-MicrosoftCloudAppSecurity"
        priority                   = "150"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "MicrosoftCloudAppSecurity"
      },                            
      # do not change
      # outbound https 443 web "172.16.1.0/24" > management infra "100.64.0.0/24"
      {
        name                       = "out-communication-allow-443-management"
        priority                   = "160"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "100.64.0.0/24"
      },
      # TODO: outbound aks to mcr, azure services via egress firewall                
      {
        name                       = "out-communication-allow-443-VirtualNetwork"
        priority                   = "170"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },      
      
    # end management outbound  

    # begin aks FQDN requirements  

      # Outbound https 443 MCR      
      {
        name                       = "out-HTTPS-MCR"
        priority                   = "200"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "MicrosoftContainerRegistry"
      },
      # Outbound https 443 MCR - AzureFrontDoor.FirstParty - pre-requisite for MCR      
      {
        name                       = "out-HTTPS-AzureFrontDoor-FirstParty"
        priority                   = "210"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureFrontDoor.FirstParty"
      },   
      # Outbound https 443 MCR - AzureResourceManager       
      {
        name                       = "out-HTTPS-AzureResourceManager"
        priority                   = "220"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureResourceManager"
      },      
      # Outbound https 443 MCR - AzureActiveDirectory       
      {
        name                       = "out-HTTPS-AzureActiveDirectory"
        priority                   = "230"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureActiveDirectory"
      }, 

      # Outbound https 443 AzureFrontDoor.Frontend 
      {
        name                       = "out-HTTPS-AzureFrontDoor.Frontend"
        priority                   = "240"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureFrontDoor.Frontend"
      }, 
      # Outbound https 443 AzureCloud                  
      {
        name                       = "out-HTTPS-AzureCloud.SouthEastAsia"
        priority                   = "250"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "AzureCloud.SouthEastAsia"
      },      
    # end aks FQDN requirements  

      # outbound https 443 app "172.16.1.0/24" > db "172.16.2.0/24"
      {
        name                       = "out-communication-allow-443-db"
        priority                   = "260"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "1443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.2.0/24"
      },
      # outbound postgresql 5432 app "172.16.1.0/24" > db "172.16.2.0/24"
      {
        name                       = "out-communication-allow-postgresql"
        priority                   = "270"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "5432"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.2.0/24"
      },  
      # outbound redis caches 6380-6383 app "172.16.1.0/24" > db "172.16.2.0/24"
      {
        name                       = "out-communication-allow-redis"
        priority                   = "280"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "6380-6383"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.2.0/24"
      }, 
      # outbound https 443 app "172.16.1.0/24" > it "172.16.3.0/24"
      {
        name                       = "out-communication-allow-https"
        priority                   = "290"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.3.0/24"
      },     
 
      {
        name                       = "out-communication-allow-80" # for testing only
        priority                   = "500"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },  
      # custom deny all outbound
      {
        name                       = "custom-deny-all-outbound"
        priority                   = "4000"
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },               
    ]
  }

  db_nsg = {
    version            = 1
    resource_group_key = "networking_spoke_re1"
    name               = "db"    
    tags = { 
      purpose = "database tier network security group"
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"           
    } 

    nsg = [  
    # management inbound
       # do not change            
      # inbound ssh 22 management bastion "100.64.2.0/24" > web "172.16.0.0/24"          
      {
        name                       = "Inbound-SSH-management"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.2.0/24"
      }, 
      {
        name                       = "Inbound-MSSQL-management"
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.2.0/24"
      },
      {
        name                       = "Inbound-POSTRESQL-management"
        priority                   = "120"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "5432"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.2.0/24"
      }, 
      {
        name                       = "Inbound-Redis-Caches-management"
        priority                   = "130"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "6380-6383"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.2.0/24"
      },           
    # end management inbound   
      # inbound mssql 1433 app "172.16.1.0/24" > db "172.16.2.0/24"         
      {
        name                       = "Inbound-MSSQL-app"
        priority                   = "200"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.2.0/24"
      },
      # inbound postgresql 5432 app "172.16.1.0/24" > db "172.16.2.0/24"        
      {
        name                       = "Inbound-POSTRESQL-app"
        priority                   = "210"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "5432"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.2.0/24"
      }, 
      # inbound Redis 6380-6383 app "172.16.1.0/24" > db "172.16.2.0/24"        
      {
        name                       = "Inbound-Redis-Caches-app"
        priority                   = "220"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "6380-6383"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.2.0/24"
      },            
      {
        name                       = "Inbound-MSSQL"
        priority                   = "230"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "Inbound-POSTRESQL"
        priority                   = "240"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "5432"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      }, 
      {
        name                       = "Inbound-Redis-Caches"
        priority                   = "250"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "6380"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },             
    ]
  }

# https://learn.microsoft.com/en-us/azure/api-management/virtual-network-reference?tabs=stv2

  it_nsg = {
    version            = 1
    resource_group_key = "networking_spoke_re1"
    name               = "it"   
    tags = { 
      purpose = "it tier network security group"
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"      
    }    
    nsg = [
    # begin management inbound   

      # do not change            
      # inbound ssh 22 management bastion "100.64.2.0/24" > it "172.16.0.0/24"          
      {
        name                       = "Inbound-SSH-management"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.3.0/24"
      }, 
      # inbound ssh 22 management bastion "100.64.2.0/24" > it "172.16.3.0/24"      
      {
        name                       = "Inbound-HTTPS-management"
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "433"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.3.0/24"
      },         
    # end management inbound           
      # inbound https 443 app "172.16.1.0/24" > it "172.16.3.0/24"      
      {
        name                       = "Inbound-HTTP-it"
        priority                   = "200"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.3.0/24"
      },  
      # inbound http 80 app "172.16.1.0/24" > it "172.16.3.0/24"           
      {
        name                       = "Inbound-HTTPS-it"
        priority                   = "210"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "172.16.1.0/24"
        destination_address_prefix = "172.16.3.0/24"
      },      
      {
        name                       = "Inbound-APIM"
        priority                   = "220"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "3443"
        source_address_prefix      = "ApiManagement"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "Inbound-LoadBalancer"
        priority                   = "230"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "6390"
        source_address_prefix      = "AzureLoadBalancer"
        destination_address_prefix = "VirtualNetwork"
      },
      # {
      #   name                       = "Outbound-StorageHttp"
      #   priority                   = "100"
      #   direction                  = "Outbound"
      #   access                     = "Allow"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "80"
      #   source_address_prefix      = "VirtualNetwork"
      #   destination_address_prefix = "Storage"
      # },     
      {
        name                       = "Outbound-StorageHttps"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "Storage"
      },
      {
        name                       = "Outbound-AADHttp"
        priority                   = "110"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "AzureActiveDirectory"
      },
      {
        name                       = "Outbound-AADHttps"
        priority                   = "120"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "AzureActiveDirectory"
      },
      {
        name                       = "Outbound-SQL"
        priority                   = "130"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "SQL"
      },
      {
        name                       = "Outbound-keyvault"
        priority                   = "140"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "AzureKeyVault.SouthEastAsia"
      },       
      {
        name                       = "Outbound-EventHub"
        priority                   = "150"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "5671-5672"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "EventHub"
      },
      {
        name                       = "Outbound-EventHubHttps"
        priority                   = "160"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "EventHub"
      },
      {
        name                       = "Outbound-FileShareGit"
        priority                   = "240"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "445"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "Storage"
      },
      {
        name                       = "Outbound-Health"
        priority                   = "260"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "1886"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "AzureCloud.SouthEastAsia"
      },
      {
        name                       = "Outbound-Monitor"
        priority                   = "170"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "AzureMonitor"
      },
      # {
      #   name                       = "Outbound-MoSMTP1itor"
      #   priority                   = "300"
      #   direction                  = "Outbound"
      #   access                     = "Allow"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "25"
      #   source_address_prefix      = "VirtualNetwork"
      #   destination_address_prefix = "INTERNET"
      # },
      # {
      #   name                       = "Outbound-SMTP2"
      #   priority                   = "320"
      #   direction                  = "Outbound"
      #   access                     = "Allow"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "587"
      #   source_address_prefix      = "VirtualNetwork"
      #   destination_address_prefix = "INTERNET"
      # },
      # {
      #   name                       = "Outbound-SMTP3"
      #   priority                   = "340"
      #   direction                  = "Outbound"
      #   access                     = "Allow"
      #   protocol                   = "tcp"
      #   source_port_range          = "*"
      #   destination_port_range     = "25028"
      #   source_address_prefix      = "VirtualNetwork"
      #   destination_address_prefix = "INTERNET"
      # },
      {
        name                       = "Outbound-Redis"
        priority                   = "180"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "6380-6383"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
    ]
  }

  gut_nsg = {
    version            = 1
    resource_group_key = "networking_spoke_re1"
    name               = "gut"    
    tags = { 
      purpose = "gut tier network security group"
      project-code = "ignite" 
      env = "sandpit" 
      zone = "internet"     
    }    
    nsg = [
    # begin management inbound          
      # do not change            
      # inbound ssh 22 management bastion "100.64.2.0/24" > gut "172.16.4.0/24"          
      {
        name                       = "Inbound-HTTP"
        priority                   = "100"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.4.0/24"
      }, 
      # inbound https 443 management bastion "100.64.2.0/24" > gut "172.16.4.0/24"      
      {
        name                       = "Inbound-MSSQL"
        priority                   = "110"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "433"
        source_address_prefix      = "100.64.2.0/24"
        destination_address_prefix = "172.16.4.0/24"
      },         
    # end management inbound  
    # begin app inbound         
      # inbound https 443 it "172.16.3.0/24" > gut "172.16.4.0/24"      
      {
        name                       = "Inbound-HTTPS-it"
        priority                   = "200"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "433"
        source_address_prefix      = "172.16.3.0/24"
        destination_address_prefix = "172.16.4.0/24"
      },           
      {
        name                       = "Inbound-HTTP-it"
        priority                   = "210"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80-82"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "Inbound-HTTPS"
        priority                   = "220"
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
    # end app inbound  
      # outbound gut > egress
      {
        name                       = "out-communication-allow-443-egress"
        priority                   = "100"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "172.16.4.0/24"
        destination_address_prefix = "172.17.0.0/24"
      },    
      {
        name                       = "out-communication-allow-443"
        priority                   = "110"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },
      {
        name                       = "out-communication-allow-80" # for testing only
        priority                   = "500"
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "VirtualNetwork"
      },   
    ]
  }


}
