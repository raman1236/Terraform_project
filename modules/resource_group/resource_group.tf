resource "azurerm_resource_group" "example" {
  count    = length(var.location)
  name     = "my-test-candidate-${count.index}"
  location = count.index
}