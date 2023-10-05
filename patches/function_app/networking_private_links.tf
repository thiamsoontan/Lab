module "private_endpoints" {
  source   = "./modules/networking/private_links/endpoints"
  for_each = try(var.networking.private_endpoints, {})

  global_settings   = local.global_settings
  client_config     = local.client_config
  resource_groups   = local.combined_objects_resource_groups
  settings          = each.value
  private_endpoints = var.networking.private_endpoints
  private_dns       = local.combined_objects_private_dns
  # TODO: can this be empty
  # check if empty, assign to empty
  # count = var.server == "MicrosoftWindowsServer" ? 0 : 1
  # value = var.object == [] ? "empty" : "not empty"
  # vnet              = each.value.vnet_key == "" ? each.value.vnet_id : (try(local.combined_objects_networking[each.value.lz_key][each.value.vnet_key], local.combined_objects_networking[local.client_config.landingzone_key][each.value.vnet_key]))
  vnet              = each.value.vnet_key == "" ? null : (try(local.combined_objects_networking[each.value.lz_key][each.value.vnet_key], local.combined_objects_networking[local.client_config.landingzone_key][each.value.vnet_key]))

  base_tags = try(local.global_settings.inherit_tags, false) ? coalesce(
    try(local.resource_groups[each.value.resource_group_key].tags, null),
    try(local.resource_groups[each.value.lz_key][each.value.resource_group_key].tags, null),
    try(local.combined_objects_resource_groups[each.value.lz_key][each.value.resource_group.key].tags, null),
    try(local.combined_objects_resource_groups[each.value.lz_key][each.value.resource_group_key].tags, null),
    try(local.combined_objects_resource_groups[local.client_config.landingzone_key][each.value.resource_group.key].tags, null),
    try(local.combined_objects_resource_groups[local.client_config.landingzone_key][each.value.resource_group_key].tags, null),
    {}
  ) : {}

  remote_objects = {
    diagnostic_storage_accounts     = local.combined_diagnostics.storage_accounts
    diagnostic_event_hub_namespaces = local.combined_diagnostics.event_hub_namespaces

    aks_clusters               = local.combined_objects_aks_clusters
    batch_accounts             = local.combined_objects_batch_accounts
    azure_container_registries = local.combined_objects_azure_container_registries
    cosmos_dbs                 = local.combined_objects_cosmos_dbs
    data_factory               = local.combined_objects_data_factory
    event_hub_namespaces       = local.combined_objects_event_hub_namespaces
    keyvaults                  = local.combined_objects_keyvaults
    machine_learning           = local.combined_objects_machine_learning
    mssql_servers              = local.combined_objects_mssql_servers
    mysql_servers              = local.combined_objects_mysql_servers
    networking                 = local.combined_objects_networking
    postgresql_servers         = local.combined_objects_postgresql_servers
    recovery_vaults            = local.combined_objects_recovery_vaults
    redis_caches               = local.combined_objects_redis_caches
    storage_accounts           = local.combined_objects_storage_accounts
    synapse_workspaces         = local.combined_objects_synapse_workspaces
    signalr_services           = local.combined_objects_signalr_services
    # TODO: Add Function_Apps
    function_apps             = local.combined_objects_function_apps
  }

}

output "private_endpoints" {
  value = module.private_endpoints
}