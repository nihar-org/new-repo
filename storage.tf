resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_storage_account" "this" {
  name                     = "${var.storage_account_prefix}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_account" "diagnostics" {
  name                     = "${var.diagnostics_storage_account_prefix}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  name               = var.storage_container_name
  storage_account_id = azurerm_storage_account.this.id
}
