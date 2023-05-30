# CAF Terraform for GCC - Lab

## Getting Started

Clone the repo to your laptop

Open the working folder in Visual Studio Code

(if required), install VSCode extension “Remote-Containers”

Note: reopen in container when prompt in VS code

## Lab 1 - GCC Development Environment

Go to /tf/caf/gcc-dev-env/README.md and follow the steps in the readme file.

## Lab 2 - Launchpad

Go to /tf/caf/gcc_starter/landingzone/configuration/level0/launchpad/README.md and follow the steps in the readme file.

## Lab 3 - Networking

Go to /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet/README.md and follow the steps in the readme file.

## Lab 4 - Solution Accelerator

Go to /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows/Readme.md and follow the steps in the readme file.


## Lab 5 - Clean up 

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level4 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level4/vm_windows \
-parallelism 30 \
-env sandpit \
-tfstate solution_accelerators_vm_windows.tfstate \
-a destroy
```

```bash
rover -lz /tf/caf/landingzones/caf_solution \
-level level3 \
-var-folder /tf/caf/gcc_starter/landingzone/configuration/level3/networking_spoke_internet \
-env sandpit \
-tfstate networking_spoke_internet.tfstate \
-a destroy
```

```bash
rover -lz /tf/caf/landingzones/caf_launchpad \
  -launchpad \
  -var-folder /tf/caf/gcc_starter/landingzone/configuration/level0/launchpad \
  -parallelism 30 \
  -env sandpit \
  -a destroy
```

```bash
cd gcc-dev-env
terraform destroy
cd ..
```


## Troubleshooting Tips
1. Unable to create KeyVault or there is existing keyvault name, then go to managed deleted vaults to ensure all deleted keyvaults are purge.
