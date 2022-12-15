#
# Managed identities from remote state
#

locals {
  managed_local_identities = flatten([
    for managed_identity_key in try(var.settings.identity.managed_identity_keys, []) : [
      var.managed_identities[var.client_config.landingzone_key][managed_identity_key].id
    ]
  ])

# terraform
  managed_remote_identities = flatten([
    for keyvault_key, value in try(var.settings.identity.remote, []) : [
      for managed_identity_key in value.managed_identity_keys : [
        var.managed_identities[keyvault_key][managed_identity_key].id
      ]
    ]
  ])

# tfvars
      # remote = {
      #   keyvault_key = "shared_services" # if managed identity is deploy at a remote landingzone
      #   value = {
      #     managed_identity_keys = ["apgw_internet_msi"]
      #   }
      # }

  # managed_remote_identities = flatten([
  #   var.managed_identities[var.settings.identity.lz_key][var.settings.identity.mi_key].id
  # ])

  #echo 'lz key:' + var.settings.identity.lz_key | terraform console

  managed_identities = concat(local.managed_local_identities, local.managed_remote_identities)
}
