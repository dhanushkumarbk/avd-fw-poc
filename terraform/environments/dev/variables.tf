variable "prefix" {
  description = "Prefix for all resources."
  type        = string
  default     = "avd-fw-poc"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "avd-fw-poc-rg"
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "avd-fw-poc-vnet"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "A map of subnets to create."
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    "AzureFirewallSubnet" = {
      name             = "AzureFirewallSubnet"
      address_prefixes = ["10.0.1.0/24"]
    },
    "AVDSubnet" = {
      name             = "AVDSubnet"
      address_prefixes = ["10.0.2.0/24"]
    }
  }
}
