terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "4.26.0"
        }
        azapi = {
            source  = "azure/azapi"
            version = "~>1.5"
        }
        random = {
            source = "hashicorp/random"
            version = "~>3.0"
        }
    }
}

provider "azurerm" {
  features {  }
}

resource "azurerm_resource_group" "azure_resource_group" {
  name      = var.azure_resource_group_name
  location  = var.azure_resource_group_location
}

module "azure_network" {
  source                                = "./modules/network"
  azure_virtual_network_name            = var.azure_virtual_network_name
  azure_resource_group_location         = var.azure_resource_group_location
  azure_resource_group_name             = var.resource_group_name
  azure_virtual_network_address_space   = var.azure_virtual_network_address_space
  azure_subnet_address_space            = var.azure_subnet_address_space
  azure_network_interface_name          = var.azure_network_interface_name
  azure_security_group_name             = var.azure_security_group_name
}