## Pre-requisites

login account must be the owner of the subscription when creating the level4

## (Optional) Login to azure

1. Open zsh terminal

2. To sign in, type the below command in the terminal
```bash
rover login
```
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code to authenticate.

3. (Optional) To set to a specific subscription, execute the below command
```bash
az account set --subscription [your subscription id] 
```

## Lab 4

1. Copy example "101-single-windows-vm" from aztfmod/examples folder to level4/vm_windows

```bash
cp /tf/caf/landingzones/aztfmod/examples/compute/virtual_machine/101-single-windows-vm/configuration.tfvars /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows/vm.tfvars
```

Open file in VS code
/tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows/vm.tfvars


2. Comment line 36 and line 37

        # vnet_key                = "vnet_region1"
        # subnet_key              = "example"

3. add subnet_id below subnet_key at line 38  as shown below

        # vnet_key                = "vnet_region1"
        # subnet_key              = "example"
        subnet_id = "/subscriptions/<subscription id>/resourceGroups/<gcc vnet resource group>/providers/Microsoft.Network/virtualNetworks/<gcc vnet name>/subnets/<prefix>-snet-app-internet<random code>"
  
  Note: 
  Replace <subscription id> with your own subscription id. 
  Replace <gcc vnet resource group> with "gcci-platform". 
  Replace <gcc vnet name> with "gcci-vnet-internet"
  Replace <random code> with the random code from the app subnet name in gcci-vnet-internet
  Replace <prefix> with the prefix you specify in level 0


4. Comment line 55-56 priority and eviction_policy - only applicable for Spot priority
        # priority        = "Spot"
        # eviction_policy = "Deallocate"
   
5. Comment line 2-7 global setting - since it is in level 0 launchpad

# global_settings = {
#   default_region = "region1"
#   regions = {
#     region1 = "australiaeast"
#   }
# }

6. Comment line 9-13 resource groups setting - since it is in current level resource_group.tfvars

# resource_groups = {
#   vm_region1 = {
#     name = "example-virtual-machine-rg1"
#   }
# }

7. Comment line 106-122 vnets configuration - since it is created in level 3 networking

# vnets = {
#   vnet_region1 = {
#     resource_group_key = "vm_region1"
#     vnet = {
#       name          = "virtual_machines"
#       address_space = ["10.100.100.0/24"]
#     }
#     specialsubnets = {}
#     subnets = {
#       example = {
#         name = "examples"
#         cidr = ["10.100.100.0/29"]
#       }
#     }

#   }
# }


## Deployment

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level4 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows \
-parallelism 30 \
-env sandpit \
-tfstate solution_accelerators_vm_windows.tfstate \
-a plan
```

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level4 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows \
-parallelism 30 \
-env sandpit \
-tfstate solution_accelerators_vm_windows.tfstate \
-a apply
```

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level4 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows \
-parallelism 30 \
-env sandpit \
-tfstate solution_accelerators_vm_windows.tfstate \
-a destroy
```
