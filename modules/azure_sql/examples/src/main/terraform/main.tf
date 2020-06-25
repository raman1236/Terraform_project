
# Setting Subscription ID
provider "azurerm" {
  features { }
  tenant_id       = "<TENANT ID>"
  subscription_id = "<SUBSCRIPTION ID>"
}
module "aot-terraform-example-az_sql" {
  source                          = "provide_the_path"
  az_sql_server_name              = var.az_sql_server_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  azuresql_adm_login              = var.azuresql_adm_login
  az_sql_version                  = var.az_sql_version
  keyvault_name                   = var.keyvault_name
  az_sql_db_name                  = var.az_sql_db_name
  azsql_adm_secrets_name          = var.azsql_adm_secrets_name
  az_sql_firewall_rule            = var.az_sql_firewall_rule
  extended_auditing_policy        = var.extended_auditing_policy
  az_sql_elasticpool_name         = var.az_sql_elasticpool_name
  az_sql_ser_secondary_name       = var.az_sql_ser_secondary_name
  secondary_location              = var.secondary_location
  elasticpool_edition             = var.elasticpool_edition
  elasticpool_dtu                 = var.elasticpool_dtu
  azurerm_sql_failover_group_name = var.azurerm_sql_failover_group_name
  failover_policy_mode            = var.failover_policy_mode
  failover_policy_grace_minutes   = var.failover_policy_grace_minutes
}
