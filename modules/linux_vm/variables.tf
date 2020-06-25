variable "resource_group_name" {
  description = "Resource Group name for MySQL server"
}
variable "teir" {
  description = "provide the name of teir example: app,web"
  type        = string
}
variable "number_of_VMs" {
  description = "provide the number of VMs need to be provisioned"
  type        = number
}