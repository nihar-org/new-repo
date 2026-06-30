resource "azurerm_service_plan" "this" {
  name                = var.web_service_plan_name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.web_app_location
  os_type             = "Linux"
  sku_name            = var.web_service_plan_sku_name

  tags = var.tags
}

resource "azurerm_service_plan" "function" {
  name                = var.function_service_plan_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = var.function_service_plan_sku_name

  tags = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  service_plan_id     = azurerm_service_plan.function.id

  storage_account_name       = azurerm_storage_account.this.name
  storage_account_access_key = azurerm_storage_account.this.primary_access_key
  https_only                 = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION = "~4"
    FUNCTIONS_WORKER_RUNTIME    = "python"
  }

  tags = var.tags
}

resource "time_sleep" "function_app_warmup" {
  create_duration = var.function_app_warmup_duration

  depends_on = [azurerm_linux_function_app.this]
}

resource "azurerm_function_app_function" "this" {
  count           = var.enable_function_definition ? 1 : 0
  name            = var.function_definition_name
  function_app_id = azurerm_linux_function_app.this.id
  language        = "Python"
  test_data       = jsonencode({ name = "Terraform" })

  file {
    name    = "__init__.py"
    content = <<-PY
def main(req):
    return "Hello from TestTFFunction"
PY
  }

  config_json = jsonencode({
    bindings = [
      {
        authLevel = "anonymous"
        direction = "IN"
        methods   = ["get"]
        name      = "req"
        type      = "httpTrigger"
      },
      {
        direction = "OUT"
        name      = "$return"
        type      = "http"
      }
    ]
  })

  depends_on = [time_sleep.function_app_warmup]
}

resource "azurerm_linux_web_app" "this" {
  count               = var.enable_web_app_stack ? 1 : 0
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.this.name
  location            = var.web_app_location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  site_config {
    always_on = false

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
  }

  tags = var.tags
}

resource "azurerm_virtual_network" "web_app" {
  count               = var.enable_web_app_stack ? 1 : 0
  name                = var.web_app_virtual_network_name
  location            = var.web_app_location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.web_app_virtual_network_cidr]

  tags = var.tags
}

resource "azurerm_subnet" "web_app_private_endpoints" {
  count                             = var.enable_web_app_stack ? 1 : 0
  name                              = var.web_app_private_endpoints_subnet_name
  resource_group_name               = azurerm_resource_group.this.name
  virtual_network_name              = azurerm_virtual_network.web_app[0].name
  address_prefixes                  = [var.web_app_private_endpoints_subnet_cidr]
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_private_endpoint" "this" {
  count               = var.enable_web_app_stack ? 1 : 0
  name                = var.private_endpoint_name
  location            = var.web_app_location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.web_app_private_endpoints[0].id

  private_service_connection {
    name                           = var.private_link_service_connection_name
    private_connection_resource_id = azurerm_linux_web_app.this[0].id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "this" {
  count               = var.enable_web_app_stack ? 1 : 0
  name                = var.private_dns_record_name
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address]

  tags = var.tags
}
