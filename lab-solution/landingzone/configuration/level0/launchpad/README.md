## Pre-requisites

login account must be the owner of the subscription when creating the launchpad
purge all deleted key vaults before apply the launchpad

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


## lab 2
Replace prefix and project code in file 
Goto file /tf/caf/gcc_starter/landingzone/configuration/level0/launchpad/global_settings.tfvars

Open file in VS code

1. Goto line 19, replace the prefix "ignite"  with your own unique 5 characters code prefix, e.g. "benng"

2. Goto line 53, replace the project code "CAF-TF" with your own unique project code, e.g. "lab1"


## Deployment

```bash
rover -lz /tf/caf/landingzones/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/gcc_starter/landingzone/configuration/level0/launchpad \
  -parallelism 30 \
  -env sandpit \
  -a plan
```

```bash
rover -lz /tf/caf/landingzones/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/gcc_starter/landingzone/configuration/level0/launchpad \
  -parallelism 30 \
  -env sandpit \
  -a apply
```  

# Next step
# Goto README.md at /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet/README.md

```bash
rover -lz /tf/caf/landingzones/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/gcc_starter/landingzone/configuration/level0/launchpad \
  -parallelism 30 \
  -env sandpit \
  -a destroy
``` 