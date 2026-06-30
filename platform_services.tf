locals {
  enable_role_definition = var.role_definition_scope_id != null
}

data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.kubernetes_cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.kubernetes_dns_prefix

  default_node_pool {
    name           = "system"
    vm_size        = var.kubernetes_default_node_pool_vm_size
    node_count     = var.kubernetes_default_node_pool_count
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = var.kubernetes_pod_cidr
    service_cidr        = var.kubernetes_service_cidr
    dns_service_ip      = var.kubernetes_dns_service_ip
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  name                  = var.kubernetes_user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.kubernetes_user_node_pool_vm_size
  node_count            = var.kubernetes_user_node_pool_count
  vnet_subnet_id        = azurerm_subnet.aks_nodes.id
  mode                  = "User"

  tags = var.tags
}

resource "azurerm_mssql_server" "this" {
  name                         = "${var.sql_server_name_prefix}${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.this.name
  location                     = var.sql_location
  version                      = "12.0"
  administrator_login          = var.sql_administrator_login
  administrator_login_password = var.sql_administrator_login_password

  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.this.id
  sku_name  = "Basic"

  tags = var.tags
}

resource "azurerm_management_group" "this" {
  display_name = var.management_group_display_name
}

resource "azurerm_key_vault" "this" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  rbac_authorization_enabled = true

  tags = var.tags
}

resource "azurerm_role_definition" "this" {
  count = local.enable_role_definition ? 1 : 0

  name        = var.role_definition_name
  scope       = var.role_definition_scope_id
  description = "TestTF custom role definition"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Storage/storageAccounts/read"
    ]
    not_actions = []
  }

  assignable_scopes = [var.role_definition_scope_id]
}

resource "azurerm_shared_image_gallery" "this" {
  name                = var.shared_image_gallery_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  description         = "TestTF shared image gallery"

  tags = var.tags
}

resource "azurerm_shared_image" "this" {
  name                = var.shared_image_name
  gallery_name        = azurerm_shared_image_gallery.this.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  hyper_v_generation  = "V2"

  identifier {
    publisher = "TestTF"
    offer     = "TestTFImageOffer"
    sku       = "TestTFImageSku"
  }

  tags = var.tags
}
