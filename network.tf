resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.virtual_network_cidr]

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_subnet" "functions" {
  name                 = var.functions_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.functions_subnet_cidr]
}

resource "azurerm_subnet" "private_endpoints" {
  name                              = var.private_endpoints_subnet_name
  resource_group_name               = azurerm_resource_group.this.name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = [var.private_endpoints_subnet_cidr]
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = var.aks_nodes_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_nodes_subnet_cidr]
}

resource "azurerm_subnet" "aks_pods" {
  name                 = var.aks_pods_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.aks_pods_subnet_cidr]
}

resource "azurerm_subnet" "private_link_service" {
  name                                          = var.private_link_service_subnet_name
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = [var.private_link_service_subnet_cidr]
  private_link_service_network_policies_enabled = false
}

resource "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  name                        = "AllowVNetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_https_outbound" {
  name                        = "AllowHTTPSOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_route_table" "this" {
  name                = var.route_table_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_route" "this" {
  name                = var.route_name
  resource_group_name = azurerm_resource_group.this.name
  route_table_name    = azurerm_route_table.this.name
  address_prefix      = var.route_address_prefix
  next_hop_type       = "None"
}

resource "azurerm_subnet_network_security_group_association" "vm" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_network_security_group_association" "functions" {
  subnet_id                 = azurerm_subnet.functions.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet_route_table_association" "aks_nodes" {
  subnet_id      = azurerm_subnet.aks_nodes.id
  route_table_id = azurerm_route_table.this.id
}

resource "azurerm_network_interface" "this" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_lb" "private_link_service" {
  name                = var.private_link_service_load_balancer_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "Primary"
    subnet_id                     = azurerm_subnet.private_link_service.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_private_link_service" "this" {
  name                = var.private_link_service_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.private_link_service.frontend_ip_configuration[0].id]

  nat_ip_configuration {
    name      = "Primary"
    primary   = true
    subnet_id = azurerm_subnet.private_link_service.id
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false

  tags = var.tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "TestTFBlobPrivateDNSLink"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false

  tags = var.tags
}

resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "TestTFKeyVaultPrivateDNSLink"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false

  tags = var.tags
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "TestTFSqlPrivateDNSLink"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "TestTFStorageBlobPrivateEndpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "TestTFStorageBlobConnection"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "TestTFKeyVaultPrivateEndpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "TestTFKeyVaultConnection"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.key_vault.id]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "sql" {
  name                = "TestTFSqlPrivateEndpoint"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "TestTFSqlConnection"
    private_connection_resource_id = azurerm_mssql_server.this.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = var.tags
}
