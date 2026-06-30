output "resource_group_name" {
  description = "Created resource group name."
  value       = azurerm_resource_group.this.name
}

output "secondary_resource_group_name" {
  description = "Created secondary resource group name."
  value       = azurerm_resource_group.secondary.name
}

output "storage_account_name" {
  description = "Created storage account name."
  value       = azurerm_storage_account.this.name
}

output "diagnostics_storage_account_name" {
  description = "Created diagnostics storage account name."
  value       = azurerm_storage_account.diagnostics.name
}

output "virtual_network_name" {
  description = "Created virtual network name."
  value       = azurerm_virtual_network.this.name
}

output "subnet_name" {
  description = "Created subnet name."
  value       = azurerm_subnet.this.name
}

output "network_interface_name" {
  description = "Created network interface name."
  value       = azurerm_network_interface.this.name
}

output "testtf_virtual_network_name" {
  description = "Created optional TestTF virtual network name."
  value       = try(azurerm_virtual_network.testtf[0].name, null)
}

output "testtf_network_interface_name" {
  description = "Created optional TestTF network interface name."
  value       = try(azurerm_network_interface.testtf[0].name, null)
}

output "testtf_network_security_group_name" {
  description = "Created optional TestTF network security group name."
  value       = try(azurerm_network_security_group.testtf[0].name, null)
}

output "testtf_virtual_machine_name" {
  description = "Created optional TestTF virtual machine name."
  value       = try(azurerm_linux_virtual_machine.testtf[0].name, null)
}

output "testtf_virtual_machine_extension_name" {
  description = "Created optional TestTF virtual machine extension name."
  value       = try(azurerm_virtual_machine_extension.testtf[0].name, null)
}

output "subnet_names" {
  description = "Created subnet names."
  value = {
    vm                   = azurerm_subnet.this.name
    functions            = azurerm_subnet.functions.name
    private_endpoints    = azurerm_subnet.private_endpoints.name
    private_link_service = azurerm_subnet.private_link_service.name
    aks_nodes            = azurerm_subnet.aks_nodes.name
    aks_pods             = azurerm_subnet.aks_pods.name
  }
}

output "network_security_group_name" {
  description = "Created network security group name."
  value       = azurerm_network_security_group.this.name
}

output "route_table_name" {
  description = "Created route table name."
  value       = azurerm_route_table.this.name
}

output "private_dns_zone_name" {
  description = "Created private DNS zone name."
  value       = azurerm_private_dns_zone.this.name
}

output "managed_disk_name" {
  description = "Created managed disk name."
  value       = azurerm_managed_disk.this.name
}

output "kubernetes_cluster_name" {
  description = "Created AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "kubernetes_user_node_pool_name" {
  description = "Created AKS user node pool name."
  value       = azurerm_kubernetes_cluster_node_pool.this.name
}

output "sql_database_name" {
  description = "Created Azure SQL database name."
  value       = azurerm_mssql_database.this.name
}

output "management_group_name" {
  description = "Created Azure Management Group name."
  value       = azurerm_management_group.this.name
}

output "key_vault_name" {
  description = "Created Azure Key Vault name."
  value       = azurerm_key_vault.this.name
}

output "role_definition_name" {
  description = "Created custom Azure role definition name."
  value       = try(azurerm_role_definition.this[0].name, null)
}

output "shared_image_name" {
  description = "Created Azure shared image name."
  value       = azurerm_shared_image.this.name
}

output "web_service_plan_name" {
  description = "Created Web App Service plan name."
  value       = azurerm_service_plan.this.name
}

output "function_service_plan_name" {
  description = "Created Function App Service plan name."
  value       = azurerm_service_plan.function.name
}

output "function_app_name" {
  description = "Created Azure Function App name."
  value       = azurerm_linux_function_app.this.name
}

output "function_definition_name" {
  description = "Created Azure Function definition name."
  value       = try(azurerm_function_app_function.this[0].name, null)
}

output "web_app_name" {
  description = "Created Azure Web App name."
  value       = try(azurerm_linux_web_app.this[0].name, null)
}

output "web_app_virtual_network_name" {
  description = "Created dedicated Web App virtual network name."
  value       = try(azurerm_virtual_network.web_app[0].name, null)
}

output "web_app_private_endpoints_subnet_name" {
  description = "Created dedicated Web App private endpoints subnet name."
  value       = try(azurerm_subnet.web_app_private_endpoints[0].name, null)
}

output "private_endpoint_name" {
  description = "Created private endpoint name."
  value       = try(azurerm_private_endpoint.this[0].name, null)
}

output "private_dns_record_name" {
  description = "Created private DNS A record name."
  value       = try(azurerm_private_dns_a_record.this[0].name, null)
}

output "private_link_service_name" {
  description = "Created Azure Private Link Service name."
  value       = azurerm_private_link_service.this.name
}

output "private_link_service_id" {
  description = "Created Azure Private Link Service ID."
  value       = azurerm_private_link_service.this.id
}

output "user_assigned_identity_name" {
  description = "Created user-assigned identity name."
  value       = azurerm_user_assigned_identity.this.name
}

output "federated_identity_credential_name" {
  description = "Created federated identity credential name."
  value       = try(azurerm_federated_identity_credential.this[0].name, null)
}

output "recovery_services_vault_name" {
  description = "Created Recovery Services vault name."
  value       = azurerm_recovery_services_vault.this.name
}

output "backup_policy_name" {
  description = "Created VM backup policy name."
  value       = azurerm_backup_policy_vm.this.name
}

output "role_assignment_ids" {
  description = "Created Azure role assignment IDs."
  value = {
    resource_group_reader          = try(azurerm_role_assignment.resource_group_reader[0].id, null)
    key_vault_access_policy_reader = try(azurerm_role_assignment.key_vault_access_policy_reader[0].id, null)
    key_vault_rbac_reader          = try(azurerm_role_assignment.key_vault_rbac_reader[0].id, null)
    virtual_network_reader         = try(azurerm_role_assignment.virtual_network_reader[0].id, null)
    storage_account_reader         = try(azurerm_role_assignment.storage_account_reader[0].id, null)
    blob_container_reader          = try(azurerm_role_assignment.blob_container_reader[0].id, null)
  }
}

output "monitor_diagnostic_setting_names" {
  description = "Created Azure Monitor diagnostic setting names."
  value       = { for key, setting in azurerm_monitor_diagnostic_setting.this : key => setting.name }
}
