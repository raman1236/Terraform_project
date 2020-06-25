data "azurerm_network_security_group" "nsg" {
    name                = var.nsg_name
    resource_group_name = var.resource_group_name
}

 data "azurerm_subnet" "example" {
    name                 = var.subnet_name
    virtual_network_name = var.virtual_network_name
    resource_group_name  = var.resource_group_name
 }

resource "azurerm_subnet_network_security_group_association" "example" {
    subnet_id                 = data.azurerm_network_security_group.nsg.id
    network_security_group_id = data.azurerm_subnet.example.id
}