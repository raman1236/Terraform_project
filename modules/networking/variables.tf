variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group"
  type        = string
}
variable "virtual_network" {
  description = "(Required) virtual network to be created"
  type        = map(object({
    name          = string
    address_space = string
}))
}
variable "subnets" {
  description = "(Required) Specifies the name of the subnets to be created"
  type        = list(object({
     subnet_name    = string
     address_prefix = string
   }))
}
variable "network_security_groups" {
  description = "(Required) Specifies the network security group to created"
  type        = list(object({
     security_rule_name                       = string
     security_rule_priority                   = number
     security_rule_protocol                   = string
     security_rule_source_port_range          = any
     security_rule_destination_port_range     = number
     security_rule_source_address_prefix      = any
     security_rule_destination_address_prefix = any
   }))
}

