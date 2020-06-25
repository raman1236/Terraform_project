provider "azurerm" {
  features { }
  tenant_id       = "<TENANT ID>"
  subscription_id = "<SUBSCRIPTION ID>"
}

module "create_resource_group" {
  source   = "../modules/resource_group"
  location = ["westus"]
}

module "base_networking_setup" {
  source              = "../modules/networking"
  resource_group_name = "my-test-candidate-${module.create_resource_group.location}"
  virtual_network     = [{
      name    = "virtual_network_westus",
      address = "10.1.0.0/20"
  }]
  subnets             = {
      subnet_web = {
        subnet_name    = "subnet_web",
        address_prefix = "10.1.1.0/24"
    },
      subnet_app = {
        subnet_name    = "subnet_app",
        address_prefix = "10.1.2.0/24"
    }
  }
  network_security_groups = {
    nsg_ssh = {
      security_rule_name                       = "SSH",
      security_rule_priority                   = "1101",
      security_rule_protocol                   = "TCP",
      security_rule_source_port_range          = "*",
      security_rule_destination_port_range     = "22",
      security_rule_source_address_prefix      = "*",
      security_rule_destination_address_prefix = "*",
    },
    nsg_web = {
      security_rule_name                       = "web_access_allow",
      security_rule_priority                   = "1102",
      security_rule_protocol                   = "TCP",
      security_rule_source_port_range          = "*",
      security_rule_destination_port_range     = "80",
      security_rule_source_address_prefix      = "*",
      security_rule_destination_address_prefix = "*",
    },
    nsg_app = {
      security_rule_name                       = "app_access_allow",
      security_rule_priority                   = "1103",
      security_rule_protocol                   = "TCP",
      security_rule_source_port_range          = "*",
      security_rule_destination_port_range     = "8080",
      security_rule_source_address_prefix      = "*",
      security_rule_destination_address_prefix = "*",
    }
  }
}

module "nsg_association_sg_ssh_to_subnet_web" {
  source                    = "../modules/nsgs"
  resource_group_name       = "my-test-candidate-${module.create_resource_group.location}"
  virtual_network_name      = "virtual_network_eastus"
  subnet_name               = "subnet_web"
  nsg_name                  = "nsg_ssh"
}

module "nsg_association_sg_ssh_to_subnet_app" {
  source                    = "../modules/nsgs"
  resource_group_name       = "my-test-candidate-${module.create_resource_group.location}"
  virtual_network_name      = "virtual_network_eastus"
  subnet_name               = "subnet_app"
  nsg_name                  = "nsg_ssh"
}

module "nsg_association_sg_web_to_subnet_web" {
  source                    = "../modules/nsgs"
  resource_group_name       = "my-test-candidate-${module.create_resource_group.location}"
  virtual_network_name      = "virtual_network_eastus"
  subnet_name               = "subnet_web"
  nsg_name                  = "nsg_web"
}

module "nsg_association_sg_app_to_subnet_app" {
  source                    = "../modules/nsgs"
  resource_group_name       = "my-test-candidate-${module.create_resource_group.location}"
  virtual_network_name      = "virtual_network_eastus"
  subnet_name               = "subnet_app"
  nsg_name                  = "nsg_app"
}

module "terraform-example-az_sql" {
  source                    = "../modules/azure_sql"
  az_sql_server_name        = "test-server-${module.create_resource_group.location}"
  location                  = module.create_resource_group.location
  resource_group_name       = "my-test-candidate-${module.create_resource_group.location}"
  azuresql_adm_login        = "azsqladmin"
  az_sql_version            = "12.0"
  keyvault_name             = "kv-${module.create_resource_group.location}" # Assumption: key vault has beed created already
  az_sql_db_name            = "test-sql-db"
  azsql_adm_secrets_name    = "test-server-${module.create_resource_group.location}-admin"

  az_sql_firewall_rule                     = {
    rule1 = {
          app_db_name_firewall_rule = "apprule1",
          start_ip_address          = "10.1.2.5",
          end_ip_address            = "10.1.2.240",
      },
  }
}

module "app-linux-VMs" {
    source              = "../modules/linux_vm"
    resource_group_name = "my-test-candidate-${module.create_resource_group.location}"
    teir                = "app"
    number_of_VMs       = "2"
}

module "web-linux-VMs" {
    source              = "../modules/linux_vm"
    resource_group_name = "my-test-candidate-${module.create_resource_group.location}"
    teir                = "web"
    number_of_VMs       = "2"
}