resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "secondary" {
  name     = var.secondary_resource_group_name
  location = var.secondary_location
}
