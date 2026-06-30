locals {
  diagnostic_targets = {
    storage_account         = azurerm_storage_account.this.id
    virtual_network         = azurerm_virtual_network.this.id
    network_interface       = azurerm_network_interface.this.id
    recovery_services_vault = azurerm_recovery_services_vault.this.id
  }
}

data "azurerm_monitor_diagnostic_categories" "this" {
  for_each    = local.diagnostic_targets
  resource_id = each.value
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each           = local.diagnostic_targets
  name               = "${replace(title(replace(each.key, "_", " ")), " ", "")}Diagnostics"
  target_resource_id = each.value
  storage_account_id = azurerm_storage_account.diagnostics.id

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this[each.key].log_category_types)
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this[each.key].metrics)
    content {
      category = enabled_metric.value
    }
  }
}
