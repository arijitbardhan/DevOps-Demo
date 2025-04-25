resource "azurerm_virtual_network" "azure_virtual_network" {
  name                = var.azure_virtual_network_name                  
  address_space       = var.azure_virtual_network_address_space
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name
}

resource "azurerm_subnet" "azure_subnet" {
  for_each              = var.azure_subnet_address_space
  name                  = each.key
  resource_group_name   = var.azure_resource_group_name
  virtual_network_name  = var.azure_virtual_network_name
  address_prefixes      = [each.value]
}

resource "azurerm_network_security_group" "azure_security_group" {
  name                = var.azure_security_group_name
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name   
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "azure_network_interface" {
  name                = var.azure_network_interface_name
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name 

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.azure_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  network_interface_id      = azurerm_network_interface.azure_network_interface.id
  network_security_group_id = azurerm_network_security_group.azure_security_group.id
}
