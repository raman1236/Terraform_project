data "azurerm_resource_group" "rg_info" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = data.azurerm_resource_group.rg_info.location
  resource_group_name = data.azurerm_resource_group.rg_info.name
}

resource "azurerm_subnet" "internal" {
  for_each             = var.subnets
  name                 = lookup(each.value,"subnet_name")
  resource_group_name  = data.azurerm_resource_group.rg_info.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = lookup(each.value,"address_prefix")
}

resource "azurerm_network_security_group" "security_group" {
    for_each            = var.network_security_groups
    name                = each.key
    location            = data.azurerm_resource_group.rg_info.location
    resource_group_name = data.azurerm_resource_group.rg_info.name

    security_rule {
        name                       = lookup(each.value,"security_rule_name")
        priority                   = lookup(each.value,"security_rule_priority")
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = lookup(each.value,"security_rule_protocol")
        source_port_range          = lookup(each.value,"security_rule_source_port_range")
        destination_port_range     = lookup(each.value,"security_rule_destination_port_range")
        source_address_prefix      = lookup(each.value,"security_rule_source_address_prefix")
        destination_address_prefix = lookup(each.value,"security_rule_destination_address_prefix")
    }
}
