output "firewall_private_ip" {
  value = azurerm_azure_firewall.fw.ip_configuration[0].private_ip_address
}
