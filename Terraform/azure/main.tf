terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "4.26.0"
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

module "azure_virtual_machine" {
  
}