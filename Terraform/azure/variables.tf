variable "azure_resource_group_name" {
  type = string
}

variable "azure_resource_group_location" {
  type      = string
  default   = "South India"
}

variable "azure_virtual_network_name" {
  type = string
}

variable "azure_virtual_network_address_space" {
  type = list(string)
}

variable "azure_subnet_address_space" {
  type = map(string)
}

variable "azure_network_interface_name" {
  type = string
}

variable "azure_security_group_name" {
  type = string
}