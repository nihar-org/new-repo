locals {
  enable_rbac_assignments = var.enable_rbac_assignments
}

resource "azurerm_role_assignment" "resource_group_reader" {
  count                = local.enable_rbac_assignments ? 1 : 0
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "key_vault_access_policy_reader" {
  count                = local.enable_rbac_assignments ? 1 : 0
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "key_vault_rbac_reader" {
  count                = local.enable_rbac_assignments ? 1 : 0
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "virtual_network_reader" {
  count                = local.enable_rbac_assignments ? 1 : 0
  scope                = azurerm_virtual_network.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "storage_account_reader" {
  count                = local.enable_rbac_assignments ? 1 : 0
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_role_assignment" "blob_container_reader" {
  count                = local.enable_rbac_assignments ? 1 : 0
  scope                = azurerm_storage_container.this.resource_manager_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}
