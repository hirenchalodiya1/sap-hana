output "anchor_vm" {
  value = local.anchor_ostype == "LINUX" ? azurerm_linux_virtual_machine.anchor : azurerm_windows_virtual_machine.anchor
}

output "resource_group" {
  value = local.rg_exists ? data.azurerm_resource_group.resource_group : azurerm_resource_group.resource_group
}

output "vnet_sap" {
  value = local.vnet_sap
}

output "storage_bootdiag" {
  value = azurerm_storage_account.storage_bootdiag
}

output "random_id" {
  value = random_id.random_id.hex
}

output "iscsi_private_ip" {
  value = local.iscsi_private_ip
}

output "ppg" {
  value = local.ppg_exists ? data.azurerm_proximity_placement_group.ppg : azurerm_proximity_placement_group.ppg
}

output "infrastructure_w_defaults" {
  value = local.infrastructure
}

output "admin_subnet" {
  value = ! local.enable_admin_subnet ? null : (local.sub_admin_exists ? data.azurerm_subnet.admin[0] : azurerm_subnet.admin[0])
}

output "db_subnet" {
  value = local.enable_db_deployment ? local.sub_db_exists ? data.azurerm_subnet.db[0] : azurerm_subnet.db[0] : null
}

output "sid_kv_user_id" {
  value = local.enable_sid_deployment && local.sid_local_credentials_exist ? azurerm_key_vault.sid_kv_user[0].id : local.kv_landscape_id
}

output "sid_kv_prvt_id" {
  value = local.enable_sid_deployment && local.sid_local_credentials_exist ? azurerm_key_vault.sid_kv_prvt[0].id : local.kv_landscape_id
}

output "storage_subnet" {
  value = local.enable_db_deployment && local.enable_storage_subnet ? (
    local.sub_storage_exists ? (
      data.azurerm_subnet.storage[0]) : (
      azurerm_subnet.storage[0]
    )) : (
    null
  )
}

output "sid_password" {
  value = coalesce(
    try(var.credentials.password, ""),
    try(data.azurerm_key_vault_secret.sid_password[0].value, ""),
    random_password.password[0].result
  )
}
