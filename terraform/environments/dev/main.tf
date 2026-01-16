terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

module "network" {
  source = "../../modules/network"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnets
}

module "firewall" {
  source = "../../modules/firewall"

  prefix              = var.prefix
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
  firewall_subnet_id  = module.network.subnet_ids["AzureFirewallSubnet"]
}

module "avd" {
  source = "../../modules/avd"

  prefix              = var.prefix
  resource_group_name = module.network.resource_group_name
  location            = module.network.location
}
