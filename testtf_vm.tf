resource "tls_private_key" "testtf" {
  count     = var.enable_testtf_vm_stack ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_network" "testtf" {
  count               = var.enable_testtf_vm_stack ? 1 : 0
  name                = var.testtf_virtual_network_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.testtf_virtual_network_cidr]

  tags = var.tags
}

resource "azurerm_subnet" "testtf" {
  count                = var.enable_testtf_vm_stack ? 1 : 0
  name                 = var.testtf_subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.testtf[0].name
  address_prefixes     = [var.testtf_subnet_cidr]
}

resource "azurerm_network_security_group" "testtf" {
  count               = var.enable_testtf_vm_stack ? 1 : 0
  name                = var.testtf_network_security_group_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "testtf_allow_ssh_inbound" {
  count                       = var.enable_testtf_vm_stack ? 1 : 0
  name                        = "TestTFAllowSSHInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.testtf[0].name
}

resource "azurerm_network_security_rule" "testtf_allow_http_inbound" {
  count                       = var.enable_testtf_vm_stack ? 1 : 0
  name                        = "TestTFAllowHTTPInbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.testtf[0].name
}

resource "azurerm_network_security_rule" "testtf_allow_https_inbound" {
  count                       = var.enable_testtf_vm_stack ? 1 : 0
  name                        = "TestTFAllowHTTPSInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.testtf[0].name
}

resource "azurerm_network_security_rule" "testtf_allow_all_inbound" {
  count                       = var.enable_testtf_vm_stack ? 1 : 0
  name                        = "TestTFAllowAllInbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.testtf[0].name
}

resource "azurerm_network_security_rule" "testtf_allow_all_outbound" {
  count                       = var.enable_testtf_vm_stack ? 1 : 0
  name                        = "TestTFAllowAllOutbound"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "0.0.0.0/0"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.testtf[0].name
}

resource "azurerm_subnet_network_security_group_association" "testtf" {
  count                     = var.enable_testtf_vm_stack ? 1 : 0
  subnet_id                 = azurerm_subnet.testtf[0].id
  network_security_group_id = azurerm_network_security_group.testtf[0].id
}

resource "azurerm_network_interface" "testtf" {
  count               = var.enable_testtf_vm_stack ? 1 : 0
  name                = var.testtf_network_interface_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "TestTFInternal"
    subnet_id                     = azurerm_subnet.testtf[0].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "testtf" {
  count                     = var.enable_testtf_vm_stack ? 1 : 0
  network_interface_id      = azurerm_network_interface.testtf[0].id
  network_security_group_id = azurerm_network_security_group.testtf[0].id
}

resource "azurerm_linux_virtual_machine" "testtf" {
  count               = var.enable_testtf_vm_stack ? 1 : 0
  name                = var.testtf_virtual_machine_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.testtf_virtual_machine_size
  admin_username      = var.testtf_admin_username
  network_interface_ids = [
    azurerm_network_interface.testtf[0].id,
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.testtf_admin_username
    public_key = tls_private_key.testtf[0].public_key_openssh
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "testtf" {
  count              = var.enable_testtf_vm_stack && var.enable_testtf_vm_data_disk_attachment ? 1 : 0
  managed_disk_id    = azurerm_managed_disk.this.id
  virtual_machine_id = azurerm_linux_virtual_machine.testtf[0].id
  lun                = 0
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "testtf" {
  count                      = var.enable_testtf_vm_stack ? 1 : 0
  name                       = var.testtf_virtual_machine_extension_name
  virtual_machine_id         = azurerm_linux_virtual_machine.testtf[0].id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    commandToExecute = "echo TestTF > /tmp/TestTF.txt"
  })
}
