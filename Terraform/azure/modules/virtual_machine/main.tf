resource "azurerm_linux_virtual_machine" "azure_linux_vm" {
  name                = var.azure_linux_vm_name
  location            = var.azure_resource_group_location
  resource_group_name = var.azure_resource_group_name 
  size                = var.azure_linux_vm_size
  admin_username      = var.azure_linux_vm_username
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = var.azure_linux_vm_username   
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}                   