resource "azurerm_recovery_services_vault" "this" {
  name                = var.recovery_services_vault_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_backup_policy_vm" "this" {
  name                = var.backup_policy_name
  resource_group_name = azurerm_resource_group.this.name
  recovery_vault_name = azurerm_recovery_services_vault.this.name

  backup {
    frequency = "Daily"
    time      = var.backup_time_utc
  }

  retention_daily {
    count = var.backup_retention_daily_count
  }
}

resource "azurerm_backup_protected_vm" "testtf" {
  count               = var.enable_testtf_vm_stack ? 1 : 0
  resource_group_name = azurerm_resource_group.this.name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  source_vm_id        = azurerm_linux_virtual_machine.testtf[0].id
  backup_policy_id    = azurerm_backup_policy_vm.this.id
}
