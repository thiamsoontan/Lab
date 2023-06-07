

## Pre-requisites

login account must be the owner of the subscription when creating the level4

## Lab 4
Replace resource group name and vnet name in file 
/tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows/vm.tfvars

Open file in VS code

1. Comment line 85 and line 86
        # vnet_key                = "vnet_region1"
        # subnet_key              = "example"

2. Add subnet_id below subnet_key at line 87 as shown below
        # vnet_key                = "vnet_region1"
        # subnet_key              = "example"
        subnet_id = "/subscriptions/<subscription id>/resourceGroups/<gcc vnet resource group>/providers/Microsoft.Network/virtualNetworks/<gcc vnet name>/subnets/ignite-snet-app-internet<random code>"
  
  Note: 
  Replace <subscription id> with your own subscription id. 
  Replace <gcc vnet resource group> with "gcci-rg-agency-vnets". 
  Replace <gcc vnet name> with "gcci-vnet-internet"
  Replace <random code> with the random code from the app subnet name in gcci-vnet-internet


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
