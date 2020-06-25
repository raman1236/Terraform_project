output "azsqlserplan_info" {
  value       = azurerm_sql_server.az_sql_server
  description = "Azure SQL server info object created"
}

output "azsqlserappdb_info" {
  value       = azurerm_sql_database.az_sql_db
  description = "Azure SQL database info object created"
}

output "azsql_firewall_rule_info" {
  value       = azurerm_sql_firewall_rule.az_sql_firewall
  description = "Azure SQL firewall_rule info object created"
}