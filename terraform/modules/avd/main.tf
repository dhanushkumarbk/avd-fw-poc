resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                     = "${var.prefix}-hp"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  host_pool_type           = "Pooled"
  load_balancer_type       = "BreadthFirst"
}

resource "azurerm_virtual_desktop_application_group" "appgroup" {
  name                = "${var.prefix}-ag"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "RemoteApp"
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
}

resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${var.prefix}-ws"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws_app_assoc" {
  workspace_id          = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id  = azurerm_virtual_desktop_application_group.appgroup.id
}
