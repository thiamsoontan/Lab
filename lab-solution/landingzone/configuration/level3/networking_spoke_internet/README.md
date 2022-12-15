

## Pre-requisites

login account must be the owner of the subscription when creating the level3

## Lab 3
Replace all resource group name and vnet name in file 
/tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet/virtual_subnets.tfvars

Open file in VS code

1. replace <subscription id> with your own subscription id

2. replace <gcc vnet resource group> with "gcci-rg-agency-vnets"

3. replace <gcc vnet name> with "gcci-vnet-internet"


## Deployment

```bash
rover -lz rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a plan
```

```bash
rover -lz rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a apply
```

```bash
rover -lz rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a destroy
```

# Next step 
# Goto README.md at /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows/Readme.md
