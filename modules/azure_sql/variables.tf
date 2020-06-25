variable "resource_group_name" {
  description = "Resource Group name for Azure SQL server"
}
variable "az_sql_server_name" {
  description = "Name of the Azure SQL server"
  type        = string
}
variable "location" {
  default     = "eastus"
  description = "Primary Azure region. Example: eastus"
}
variable "az_sql_version" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  type        = string
}
variable "azuresql_adm_login" {
  description = "The Administrator Login for the Azure SQL Server"
  type        = string
}
variable "extended_auditing_policy" {
  type = list(object(
    {
      storage_endpoint                        = string
      storage_account_access_key              = string
      storage_account_access_key_is_secondary = bool
      retention_in_days                       = number
    }))
  default = []
}
variable "keyvault_name" {
  description = "key vault to store secrets in"
  default     = null
  type        = string
}
variable "azsql_adm_secrets_name" {
  description = "name of the secret key to store in key vault secret"
  default     = null
  type        = string
}
variable "az_sql_db_name" {
  description = "The name of the database to create"
  type        = string
  default     = null
}
variable "az_sql_firewall_rule" {
  description = "Contains a map of firewall rule details"
  type        = map(object({
    app_db_name_firewall_rule = string
    start_ip_address          = string
    end_ip_address            = string
  }))
  default     = {}
}
variable "az_sql_db_edition" {
  description = "If not using Elastic Pools, The edition of the database to be created. Valid values are: Basic, Standard, Premium, DataWarehouse, Business, BusinessCritical, Free, GeneralPurpose, Hyperscale, Premium, PremiumRS, Standard, Stretch, System, System2, or Web."
  default     = "Basic"
  type        = string
}
variable "az_sql_db_service_objective" {
  description = "If not using Elastic Pools, The service objective name for the database. Valid values depend on edition and location and may include Basic, S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool."
  default     = "Basic"
  type        = string
}
variable "az_sql_elasticpool_name" {
  description = "If using Elasticpool, the Elasticpool name"
  default     = null
  type        = string
}
variable "elasticpool_edition" {
  description = "If using Elastic Pools, The edition of the elastic pool to be created. Valid values are Basic, Standard, and Premium"
  default     = "Basic"
  type        = string
}
variable "elasticpool_dtu" {
  description = "If using Elastic Pools, The total shared DTU for the elastic pool. Valid values depend on the edition which has been defined"
  default     = "50"
  type        = number
}
variable "elasticpool_db_dtu_min" {
  description = "If using Elastic Pools, The minimum DTU which will be guaranteed to all databases in the elastic pool to be created"
  default     = "0"
  type        = number
}
variable "elasticpool_db_dtu_max" {
  description = "If using Elastic Pools, If using Elasticpool, The maximum DTU which will be guaranteed to all databases in the elastic pool to be created"
  default     = "5"
  type        = number
}
variable "elasticpool_pool_size" {
  description = "If using Elastic Pools,  The maximum size in MB that all databases in the elastic pool can grow to"
  default     = "5000"
  type        = number
}
variable "az_sql_ser_secondary_name" {
  description = "Specify the azure sql secondary server name only if you are opting for failover"
  default     = null
  type        = string
}
variable "secondary_location" {
  description = "Specify the azure sql secondary location, should be different from the primary"
  default     = null
  type        = string
}
variable "azurerm_sql_failover_group_name" {
  description = "Specify the failover group name only if you are opting for failover"
  default     = null
  type        = string
}
variable "failover_policy_mode" {
  description = "Specify the failover policy mode only if you are opting for failover"
  default     = "Automatic"
  type        = string
}
variable "failover_policy_grace_minutes" {
  description = "Specify the failover policy grace minutes only if you are opting for failover"
  default     = "60"
  type        = number
}
