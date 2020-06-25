data "azurerm_resource_group" "rg_info" {
  name = var.resource_group_name
}

resource "azurerm_network_interface" "test" {
 count               = var.number_of_VMs
 name                = "${var.teir}ni${count.index}"
 location             = data.azurerm_resource_group.rg_info.location
 resource_group_name  = var.resource_group_name

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = azurerm_subnet.test.id
   private_ip_address_allocation = "dynamic"
 }
}

resource "azurerm_managed_disk" "test" {
 count                = var.number_of_VMs
 name                 = "datadisk_existing_${count.index}"
 location             = data.azurerm_resource_group.rg_info.location
 resource_group_name  = var.resource_group_name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
 name                         = var.teir
 location                     = data.azurerm_resource_group.rg_info.location
 resource_group_name          = var.resource_group_name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}

resource "azurerm_virtual_machine" "test" {
 count                 = var.number_of_VMs
 name                  = "${teir}vm${count.index}"
 location              = azurerm_resource_group.test.location
 availability_set_id   = azurerm_availability_set.avset.id
 resource_group_name   = azurerm_resource_group.test.name
 network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
 vm_size               = "Standard_DS1_v2"

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 # Optional data disks
 storage_data_disk {
   name              = "datadisk_new_${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "1023"
 }

 storage_data_disk {
   name            = element(azurerm_managed_disk.test.*.name, count.index)
   managed_disk_id = element(azurerm_managed_disk.test.*.id, count.index)
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = element(azurerm_managed_disk.test.*.disk_size_gb, count.index)
 }

 os_profile {
   computer_name  = "${teir}vm${count.index}"
   admin_username = "testadmin"
   admin_password = data.azurerm_key_vault_secret.testadmin.value
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }
}

# Assume Key_vault_secrect for testadmin is already created manualy before
data "azurerm_key_vault_secret" "testadmin" {
  name         = "testadmin"
  key_vault_id = var.key_vault_id
}