output "azure_virtual_network_network_id" {
  value = azurerm_virtual_network.azure_virtual_network.id
}

output "azure_subnet_id" {
  value = azurerm_subnet.azure_subnet.id
}

output "azure_network_security_group_id" {
  value = azurerm_network_security_group.azure_security_group.id
}

output "azure_network_interface_id" {
  value = azurerm_network_interface.azure_network_interface.id
}