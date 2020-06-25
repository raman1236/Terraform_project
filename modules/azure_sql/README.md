# Azure SQL Server
Use this module to create Azure SQL server and optionally used to create Database, firewall rules, elasticpool, failover policy. When creating Database and firewall rules values for "az_sql_db_name" and "az_sql_firewall_rule" variables must be passed respectively. Below examples show module usage. Also optionally imports sensitive information to keyvault. To add administrator_login_password to keyvault access policy, a keyvault name should be provided for var.keyvault_name. More examples can be found in examples directory 
### Example Usage
Below example creates just one Azure SQL Server
~~~
module "aot-terraform-example-az_sql" {
  source                 = "Provide the path"
  az_sql_server_name     = "test-az-server"
  location               = "eastus"
  resource_group_name    = "eastus-rg"
  azuresql_adm_login     = "azsqladmin"
  az_sql_version         = "12.0"
  }
~~~
Below example creates Azure SQL Server with Database
~~~
module "aot-terraform-example-az_sql" {
  source                      = "Provide the path"
  az_sql_server_name          = "test-az-server"
  location                    = "eastus"
  resource_group_name         = "nonprod-eastus-rg"
  azuresql_adm_login          = "azsqladmin"
  az_sql_version              = "12.0"
  keyvault_name               = "prod-kv"
  az_sql_db_name              = "test-az-sql-db"
  az_sql_db_edition           = "Basic"
  az_sql_db_service_objective = "Basic"
 }
~~~
Below shows how a module output can be used
~~~
output "azsqlserplan_info" {
  value       = module.aot-terraform-example-az_sql.azsqlserplan_info
  description = "Azure SQL server info object created"
}
output "azsqlserappdb_info" {
  value       = module.aot-terraform-example-az_sql.azsqlserappdb_info
  description = "Azure SQL database info object created"
}
output "azsql_firewall_rule_info" {
  value       = module.aot-terraform-example-az_sql.azsql_firewall_rule_info
  description = "Azure SQL firewall_rule info object created"
}
~~~
### Input Variables
 - **var.resource_group_name**: Resource Group name for Azure SQL server
 - **var.location**: Primary Azure region. Example: eastus
 - **var.az_sql_server_name**: Name of the Azure SQL server
 - **var.azuresql_adm_login**: The Administrator Login for the Azure SQL Server
 - **var.az_sql_version**: The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)
 - **var.app_db_name**: The name of the database to create

### Optional Variables
 - **var.az_sql_db_name**: Name of the Azure SQL server
 - **var.az_sql_firewall_rule**: a map of objects to provide firewall rulename, start IP address and end IP address
 - **var.extended_auditing_policy**: a map of objects to provide storage_endpoint, storage_account_access_key, storage_account_access_key_is_secondary and retention_in_days
 - **var.keyvault_name** key vault to store secrets in
 - **var.azsql_adm_secrets_name**: name of the secret key to store in key vault secret
 - **var.az_sql_db_edition**: If not using Elastic Pools, The edition of the database to be created. Valid values are: Basic, Standard, Premium, DataWarehouse, Business, BusinessCritical, Free, GeneralPurpose, Hyperscale, Premium, PremiumRS, Standard, Stretch, System, System2, or Web.
 - **var.az_sql_db_service_objective**: If not using Elastic Pools, The service objective name for the database. Valid values depend on edition and location and may include Basic, S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool.
 - **var.az_sql_elasticpool_name**: If using Elastic Pools, the Elasticpool name
 - **var.elasticpool_dtu**: If using Elastic Pools, The total shared DTU for the elastic pool. Valid values depend on the edition which has been defined
 - **var.elasticpool_db_dtu_min**: If using Elastic Pools, The minimum DTU which will be guaranteed to all databases in the elastic pool to be created
 - **var.elasticpool_db_dtu_max**: If using Elastic Pools, If using Elasticpool, The maximum DTU which will be guaranteed to all databases in the elastic pool to be created
 - **var.elasticpool_pool_size**: If using Elastic Pools,  The maximum size in MB that all databases in the elastic pool can grow to
 - **var.az_sql_ser_secondary_name**: Specify the azure sql secondary server name only if you are opting for failover
 - **var.secondary_location**: Specify the azure sql secondary location, should be different from the primary
 - **var.azurerm_sql_failover_group_name**: Specify the failover group name only if you are opting for failover
 - **var.failover_policy_mode**: Specify the failover policy mode only if you are opting for failover
 - **var.failover_policy_grace_minutes**: Specify the failover policy grace minutes only if you are opting for failover (Default 60)
