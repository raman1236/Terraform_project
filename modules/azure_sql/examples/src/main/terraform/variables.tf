variable "resource_group_name" {
  description = "Resource Group name for MySQL server"
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
  description = "Specifies the version of Azure SQL to use. Valid values are 5.6, 5.7, and 8.0"
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
  default = null
  type    = string
}
variable "azsql_adm_secrets_name" {
  description = "name of the secret key to store in key vault secret"
  default     = null
  type        = string
}
variable "az_sql_db_name" {
  description = "Contains a map of az sql database details"
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
variable "az_sql_elasticpool_name" {
  description = "Elasticpool name"
  default     = null
  type        = string
}
variable "elasticpool_edition" {
  description = "The edition of the elastic pool to be created. Valid values are Basic, Standard, and Premium"
  default     = "Basic"
  type        = string
}
variable "elasticpool_dtu" {
  description = "The total shared DTU for the elastic pool. Valid values depend on the edition which has been defined"
  default     = "50"
  type        = number
}
variable "elasticpool_db_dtu_min" {
  description = "(Optional)The minimum DTU which will be guaranteed to all databases in the elastic pool to be created"
  default     = "0"
  type        = number
}
variable "elasticpool_db_dtu_max" {
  description = "(Optional)The maximum DTU which will be guaranteed to all databases in the elastic pool to be created"
  default     = "5"
  type        = number
}
variable "elasticpool_pool_size" {
  description = "(Optional) The maximum size in MB that all databases in the elastic pool can grow to"
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
