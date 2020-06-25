### Answer for Question 1:
“resource_group” Terraform module is created under modules directory  

### Answer for Question 2:
Terraform Modules are created under modules directory
“networking” – for network related configurations 
“linux_vm” – for creating VMs
“azure_sql” – for creating azure SQL service
“nsgs” – for Associating subnets to nsgs 

Two different root modules (main.tf) are created under Region specific folders namely 
“eastus”, “westus” for easy management, if we want to increase the number of resources, we can edit respective main.tf files 

Azure Migration solution: The Migration solution is driven based on some assumption 
To answer this question, we followed Azure suggested steps for migration effect, which includes guidance, methodology and the usage of cloud-native tools from Azure
Assuming Below steps are followed:
Assess each workload's technical fit. Validate the technical readiness and suitability for migration using Azure Migrate tool to create server migration project with details 
Using SQL Server Migration Assistant for Database Migration 

Form: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/migrate/azure-migration-guide/migrate?tabs=Tools

Cloud Infrastructure requirements to be created 
1.	We are hosting in two Regions ( EastUS, WestUS ) and peering back to on-premise data center using ExpressRoute
2.	Creating two VNET’s one each in Regions ( EastUS, WestUS ) 
~~~
o	name    = "virtual_network_eastus", address = "10.2.0.0/20"
o	name    = "virtual_network_westus", address = "10.1.0.0/20”
~~~
3.	Creating two subnets for each of above VENT’s, total 4 
virtual_network_eastus
~~~
o	Subnet for web traffic = { subnet_name    = "subnet_web", address_prefix = "10.2.1.0/24"},
o	 Subnet to app traffic = { subnet_name    = "subnet_app", address_prefix = "10.2.2.0/24" }
~~~
virtual_network_westus
~~~~
o	Subnet for web traffic = { subnet_name    = "subnet_web", address_prefix = "10.1.1.0/24"},
o	 Subnet to app traffic = { subnet_name    = "subnet_app", address_prefix = "10.1.2.0/24" }
~~~
4.	Creating 4 NSG’s namely: 
nsg_ssh - To allow SSH access, which is later associated to all subnets 
nsg_web - To allow Web traffic hitting port 80, which is later associated to subnet_web
nsg App – To allow App traffic hitting port 8080, which is later associated to subnet_app

5.	Azure SQL server and Database created using azure_sql module, later on we can migrate Database form on premise to Azure using SQL Server Migration Assistant (Database is only accessible to subnet_app (only traffic form application VM) with the help of firewall rule)
6.	VMs for Webserver and Application are created using linux_vm module.
In each region we are creating two VMs for webservers (to secure the application using Apache webserver configured via single sign on, and allow traffic only for port 80 with the help of  preconfigured NSG’s - nsg_web), two VMs for Application ( TCserver , which allows traffic from webservers only with the help of preconfigured NSG’s - nsg_app)  

If I have more time, I should have also done below tasks 
1.	To allow traffic across VNETs we can use VNT Peering 
2.	For HA I have plans to create a Azure Load balancer in between app and web VMs, and Configure Network Traffic Manger in between Load balancers from different Regions for Geo redundancy 
3.	Better Documentation for modules with example usage – right now only available for Azure SQL module 
4.	Add output.tf for respective modules 
5.	Network infrastructure diagram
