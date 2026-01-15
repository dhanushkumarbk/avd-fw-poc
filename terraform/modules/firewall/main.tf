resource "azurerm_public_ip" "fw_pip" {
  name                = "${var.prefix}-fw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = "${var.prefix}-fw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
}

resource "azurerm_firewall_network_rule_collection" "allow_all" {
  name                = "allow-all-outbound"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "allow-all"
    source_addresses = ["*"]
    destination_ports = ["*"]
    destination_addresses = ["*"]
    protocols = ["Any"]
  }
}
