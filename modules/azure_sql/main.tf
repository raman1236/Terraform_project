resource "random_password" "azuresql_adm_pass" {
  length = 12
  special = true
}

data "azurerm_key_vault" "kv" {
  count               = var.keyvault_name != null ? 1 : 0
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_sql_server" "az_sql_server" {
  name                         = var.az_sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.az_sql_version
  administrator_login          = var.azuresql_adm_login
  administrator_login_password = random_password.azuresql_adm_pass.result

  dynamic "extended_auditing_policy" {
    for_each = var.extended_auditing_policy
    content {
      storage_endpoint                        = extended_auditing_policy.value.storage_endpoint
      storage_account_access_key              = extended_auditing_policy.value.storage_account_access_key
      storage_account_access_key_is_secondary = extended_auditing_policy.value.storage_account_access_key_is_secondary
      retention_in_days                       = extended_auditing_policy.value.retention_in_days
    }
  }
}

resource "azurerm_sql_database" "az_sql_db" {
  count                            = var.az_sql_db_name != null ? 1 : 0
  name                             = var.az_sql_db_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.az_sql_server.name
  edition                          = var.az_sql_elasticpool_name == null ? var.az_sql_db_edition : null
  requested_service_objective_name = var.az_sql_elasticpool_name == null ? var.az_sql_db_service_objective : null
}

resource "azurerm_key_vault_secret" "azsql_adm_secrets" {
  count        = var.keyvault_name != null ? 1 : 0
  name         = var.azsql_adm_secrets_name
  value        = random_password.azuresql_adm_pass.result
  key_vault_id = data.azurerm_key_vault.kv.0.id
}

resource "azurerm_sql_firewall_rule" "az_sql_firewall" {
  for_each            = var.az_sql_firewall_rule
  name                = each.value["app_db_name_firewall_rule"]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.az_sql_server.name
  start_ip_address    = each.value["start_ip_address"]
  end_ip_address      = each.value["end_ip_address"]
}

resource "azurerm_sql_elasticpool" "az_elasticpool" {
  count               = var.az_sql_elasticpool_name != null ? 1 : 0
  name                = var.az_sql_elasticpool_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.az_sql_server.name
  edition             = var.elasticpool_edition
  dtu                 = var.elasticpool_dtu
  db_dtu_min          = var.elasticpool_db_dtu_min
  db_dtu_max          = var.elasticpool_db_dtu_max
  pool_size           = var.elasticpool_pool_size
}

resource "azurerm_sql_server" "secondary" {
  count                        = var.azurerm_sql_failover_group_name != null ? 1 : 0
  name                         = var.az_sql_ser_secondary_name
  resource_group_name          = var.resource_group_name
  location                     = var.secondary_location
  version                      = var.az_sql_version
  administrator_login          = var.azuresql_adm_login
  administrator_login_password = random_password.azuresql_adm_pass.result
}

resource "azurerm_sql_failover_group" "az_sql_failover" {
  count               = var.azurerm_sql_failover_group_name != null ? 1 : 0
  name                = var.azurerm_sql_failover_group_name
  resource_group_name = var.resource_group_name
  server_name         = var.az_sql_server_name
  databases           = [azurerm_sql_database.az_sql_db.0.id]
  partner_servers {
    id = azurerm_sql_server.secondary.0.id
  }

  read_write_endpoint_failover_policy {
    mode          = var.failover_policy_mode
    grace_minutes = var.failover_policy_grace_minutes
  }
}
