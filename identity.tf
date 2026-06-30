locals {
  enable_federated_identity_credential = var.federated_issuer != null && var.federated_subject != null && length(var.federated_audiences) > 0
}

resource "azurerm_user_assigned_identity" "this" {
  name                = var.user_assigned_identity_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_federated_identity_credential" "this" {
  count               = local.enable_federated_identity_credential ? 1 : 0
  name                = var.federated_identity_credential_name
  resource_group_name = azurerm_resource_group.this.name
  audience            = var.federated_audiences
  issuer              = var.federated_issuer
  parent_id           = azurerm_user_assigned_identity.this.id
  subject             = var.federated_subject
}
