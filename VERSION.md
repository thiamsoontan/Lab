Versions:

terraform: Terraform version v1.5.0-rc1
aztfmod/caf/azurerm: registry.terraform.io/aztfmod/caf/azurerm 5.6.9
landingzones: 5.6.9 
  - git clone https://github.com/Azure/caf-terraform-landingzones.git /tf/caf/landingzones
azurerm: 3.59
  - file to check: /tf/caf/landingzones/aztfmod/main.tf
aztfmod: 5.7.0-preview0 
  - git clone https://github.com/aztfmod/terraform-azurerm-caf.git /tf/caf/landingzones/aztfmod 
  - git checkout 5.7.0-preview0

- Using previously-installed azure/azapi v1.3.0
- Using previously-installed hashicorp/time v0.9.1
- Using previously-installed hashicorp/local v2.4.0
- Using previously-installed hashicorp/azuread v2.39.0
- Using previously-installed hashicorp/azurerm v3.59.0 >>>>>> https://registry.terraform.io/providers/hashicorp/azurerm/latest
- Using previously-installed hashicorp/external v2.2.3
- Using previously-installed hashicorp/null v3.1.1
- Using previously-installed hashicorp/random v3.3.2
- Using previously-installed hashicorp/tls v3.1.0
- Using previously-installed aztfmod/azurecaf v1.2.25 >>>>>> https://github.com/aztfmod/terraform-provider-azurecaf