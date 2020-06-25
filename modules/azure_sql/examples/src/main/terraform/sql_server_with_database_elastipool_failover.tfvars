az_sql_server_name                       = "test-server"
location                                 = "eastus"
resource_group_name                      = "eastus-rg"
azuresql_adm_login                       = "azsqladmin"
az_sql_version                           = "12.0"
keyvault_name                            = "nonprod-kv"
az_sql_db_name                           = "test-sql-db"
azsql_adm_secrets_name                   = "az-sql-db-admin"

az_sql_firewall_rule                     = {
    rule1 = {
          app_db_name_firewall_rule = "apprule1",
          start_ip_address          = "40.112.8.12",
          end_ip_address            = "40.112.8.12",
      },
  }

extended_auditing_policy = [{
   storage_endpoint                        = "https://< STORAGE ACCOUNT >.web.core.windows.net/",
   storage_account_access_key              = "< ACCESS KEY >",
   storage_account_access_key_is_secondary = true,
   retention_in_days                       = 6,
  }]

az_sql_elasticpool_name                 = "test-pool"
az_sql_ser_secondary_name               = "secondary-az-sql"
secondary_location                      = "westus"
elasticpool_edition                     = "Basic"
elasticpool_dtu                         = 50
azurerm_sql_failover_group_name         = "exapmle-failover"
failover_policy_mode                    = "Automatic"
failover_policy_grace_minutes           = 60
