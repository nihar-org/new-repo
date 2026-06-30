resource "azurerm_managed_disk" "this" {
  name                 = var.managed_disk_name
  location             = azurerm_resource_group.this.location
  resource_group_name  = azurerm_resource_group.this.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.managed_disk_size_gb

  tags = var.tags
}
