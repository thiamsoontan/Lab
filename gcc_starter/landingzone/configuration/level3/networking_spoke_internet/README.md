

## Pre-requisites

login account must be the owner of the subscription when creating the level3

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

## Lab 3
Replace all resource group name and vnet name in file 
/tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet/virtual_subnets.tfvars

Open file in VS code

1. replace <subscription id> with your own subscription id

2. replace <gcc vnet resource group> with "gcci-platform"

3. replace <gcc vnet name> with "gcci-vnet-internet"


## Deployment

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a plan
```

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a apply
```

# Next step 
# Goto README.md at /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows/Readme.md

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a destroy
```

