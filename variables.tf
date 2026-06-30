variable "resource_group_name" {
  description = "Name of the Azure resource group to create."
  type        = string
  default     = "TestTFRG"
}

variable "location" {
  description = "Azure region for the resource group and storage account."
  type        = string
  default     = "eastus"
}

variable "secondary_resource_group_name" {
  description = "Name of the secondary Azure resource group to create in another region."
  type        = string
  default     = "TestTFSecondaryRG"
}

variable "secondary_location" {
  description = "Azure region for the secondary resource group."
  type        = string
  default     = "westus2"
}

variable "virtual_network_name" {
  description = "Name of the virtual network to create."
  type        = string
  default     = "TestTFPrimaryVNet"
}

variable "virtual_network_cidr" {
  description = "CIDR range for the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the subnet to create."
  type        = string
  default     = "TestTFVMSubnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "functions_subnet_name" {
  description = "Name of the functions subnet to create."
  type        = string
  default     = "TestTFFunctionsSubnet"
}

variable "functions_subnet_cidr" {
  description = "CIDR range for the functions subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_endpoints_subnet_name" {
  description = "Name of the private endpoints subnet to create."
  type        = string
  default     = "TestTFPrivateEndpointsSubnet"
}

variable "private_endpoints_subnet_cidr" {
  description = "CIDR range for the private endpoints subnet."
  type        = string
  default     = "10.0.3.0/24"
}

variable "aks_nodes_subnet_name" {
  description = "Name of the AKS nodes subnet to create."
  type        = string
  default     = "TestTFAKSNodesSubnet"
}

variable "aks_nodes_subnet_cidr" {
  description = "CIDR range for the AKS nodes subnet."
  type        = string
  default     = "10.0.4.0/22"
}

variable "aks_pods_subnet_name" {
  description = "Name of the AKS pods subnet to create."
  type        = string
  default     = "TestTFAKSPodsSubnet"
}

variable "aks_pods_subnet_cidr" {
  description = "CIDR range for the AKS pods subnet."
  type        = string
  default     = "10.0.8.0/21"
}

variable "private_link_service_subnet_name" {
  description = "Name of the Private Link Service subnet to create."
  type        = string
  default     = "TestTFPrivateLinkServiceSubnet"
}

variable "private_link_service_subnet_cidr" {
  description = "CIDR range for the Private Link Service subnet."
  type        = string
  default     = "10.0.16.0/24"
}

variable "network_security_group_name" {
  description = "Name of the network security group to create."
  type        = string
  default     = "TestTFPrimaryNSG"
}

variable "route_table_name" {
  description = "Name of the route table to create."
  type        = string
  default     = "TestTFRouteTable"
}

variable "route_name" {
  description = "Name of the route to create."
  type        = string
  default     = "TestTFBlackholeRoute"
}

variable "route_address_prefix" {
  description = "Address prefix for the test route."
  type        = string
  default     = "192.0.2.0/24"
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone to create."
  type        = string
  default     = "TestTF.Internal"
}

variable "private_dns_zone_virtual_network_link_name" {
  description = "Name of the private DNS zone virtual network link."
  type        = string
  default     = "TestTFPrivateDNSLink"
}

variable "network_interface_name" {
  description = "Name of the network interface to create."
  type        = string
  default     = "TestTFPrimaryNIC"
}

variable "private_link_service_load_balancer_name" {
  description = "Name of the Standard Load Balancer used by the Private Link Service."
  type        = string
  default     = "TestTFPrivateLinkServiceLB"
}

variable "private_link_service_name" {
  description = "Name of the Azure Private Link Service."
  type        = string
  default     = "TestTFPrivateLinkService"
}

variable "enable_testtf_vm_stack" {
  description = "Whether to create the optional TestTF virtual network, NIC, NSG, VM, and VM extension stack."
  type        = bool
  default     = false
}

variable "testtf_virtual_network_name" {
  description = "Name of the optional TestTF virtual network."
  type        = string
  default     = "TestTFVNet"
}

variable "testtf_virtual_network_cidr" {
  description = "CIDR range for the optional TestTF virtual network."
  type        = string
  default     = "10.20.0.0/16"
}

variable "testtf_subnet_name" {
  description = "Name of the optional TestTF subnet."
  type        = string
  default     = "TestTFSubnet"
}

variable "testtf_subnet_cidr" {
  description = "CIDR range for the optional TestTF subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "testtf_network_security_group_name" {
  description = "Name of the optional TestTF network security group."
  type        = string
  default     = "TestTFNSG"
}

variable "testtf_network_interface_name" {
  description = "Name of the optional TestTF network interface."
  type        = string
  default     = "TestTFNIC"
}

variable "testtf_virtual_machine_name" {
  description = "Name of the optional TestTF virtual machine."
  type        = string
  default     = "TestTFVM"
}

variable "testtf_virtual_machine_size" {
  description = "Size of the optional TestTF virtual machine."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "testtf_admin_username" {
  description = "Admin username for the optional TestTF virtual machine."
  type        = string
  default     = "azureuser"
}

variable "testtf_virtual_machine_extension_name" {
  description = "Name of the optional TestTF virtual machine extension."
  type        = string
  default     = "TestTFVMExtension"
}

variable "managed_disk_name" {
  description = "Name of the managed disk to create."
  type        = string
  default     = "TestTFManagedDisk"
}

variable "managed_disk_size_gb" {
  description = "Size of the managed disk in GB."
  type        = number
  default     = 32
}

variable "enable_testtf_vm_data_disk_attachment" {
  description = "Whether to attach the managed disk to the optional TestTF virtual machine."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace used by AKS monitoring."
  type        = string
  default     = "TestTFLogAnalytics"
}

variable "kubernetes_cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
  default     = "TestTFAKSCluster"
}

variable "kubernetes_dns_prefix" {
  description = "DNS prefix for the AKS cluster. Must remain lowercase to satisfy AKS naming requirements."
  type        = string
  default     = "testtfaks"
}

variable "kubernetes_default_node_pool_vm_size" {
  description = "VM size for the AKS default node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_default_node_pool_count" {
  description = "Node count for the AKS default node pool."
  type        = number
  default     = 1
}

variable "kubernetes_user_node_pool_name" {
  description = "Name of the AKS user node pool. Must remain lowercase to satisfy AKS naming requirements."
  type        = string
  default     = "userpool"
}

variable "kubernetes_user_node_pool_vm_size" {
  description = "VM size for the AKS user node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_user_node_pool_count" {
  description = "Node count for the AKS user node pool."
  type        = number
  default     = 1
}

variable "kubernetes_pod_cidr" {
  description = "Pod CIDR for AKS overlay networking."
  type        = string
  default     = "10.240.0.0/16"
}

variable "kubernetes_service_cidr" {
  description = "Service CIDR for AKS."
  type        = string
  default     = "10.250.0.0/16"
}

variable "kubernetes_dns_service_ip" {
  description = "DNS service IP for AKS."
  type        = string
  default     = "10.250.0.10"
}

variable "sql_server_name_prefix" {
  description = "Lowercase prefix for the Azure SQL logical server name. A random suffix is appended automatically."
  type        = string
  default     = "testtfsql"
}

variable "sql_location" {
  description = "Azure region for the Azure SQL logical server."
  type        = string
  default     = "westus2"
}

variable "sql_database_name" {
  description = "Name of the Azure SQL database."
  type        = string
  default     = "TestTFSqlDatabase"
}

variable "sql_administrator_login" {
  description = "Administrator login for the Azure SQL logical server."
  type        = string
  default     = "testtfadmin"
}

variable "sql_administrator_login_password" {
  description = "Administrator login password for the Azure SQL logical server."
  type        = string
  sensitive   = true
  default     = "TestTFSqlPassword123!"
}

variable "management_group_display_name" {
  description = "Display name for the Azure Management Group."
  type        = string
  default     = "TestTFManagementGroup"
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault. Must remain lowercase to satisfy Key Vault naming requirements."
  type        = string
  default     = "testtfkeyvault01"
}

variable "role_definition_scope_id" {
  description = "Scope ID where the custom role definition should be created."
  type        = string
  default     = null
  nullable    = true
}

variable "role_definition_name" {
  description = "Name of the custom Azure role definition."
  type        = string
  default     = "TestTFCustomReaderRole"
}

variable "shared_image_gallery_name" {
  description = "Name of the Azure Shared Image Gallery."
  type        = string
  default     = "TestTFImageGallery"
}

variable "shared_image_name" {
  description = "Name of the Azure Shared Image."
  type        = string
  default     = "TestTFVirtualMachineImage"
}

variable "web_service_plan_name" {
  description = "Name of the App Service plan used by the Web App."
  type        = string
  default     = "TestTFWebServicePlan"
}

variable "web_service_plan_sku_name" {
  description = "SKU for the App Service plan used by the Web App."
  type        = string
  default     = "B1"
}

variable "web_app_location" {
  description = "Azure region for the Web App stack and its dedicated App Service plan."
  type        = string
  default     = "westus2"
}

variable "function_service_plan_name" {
  description = "Name of the App Service plan used by the Function App."
  type        = string
  default     = "TestTFFunctionServicePlan"
}

variable "function_service_plan_sku_name" {
  description = "SKU for the App Service plan used by the Function App."
  type        = string
  default     = "Y1"
}

variable "enable_function_definition" {
  description = "Whether to create the sample Azure Function definition inside the Function App."
  type        = bool
  default     = false
}

variable "enable_web_app_stack" {
  description = "Whether to create the Web App, private endpoint, and private DNS A record stack."
  type        = bool
  default     = true
}

variable "function_app_name" {
  description = "Name of the Azure Function App."
  type        = string
  default     = "TestTFFunctionApp"
}

variable "function_definition_name" {
  description = "Name of the Azure Function definition."
  type        = string
  default     = "TestTFFunctionDefinition"
}

variable "function_app_warmup_duration" {
  description = "Time to wait after Function App creation before creating the function definition."
  type        = string
  default     = "90s"
}

variable "web_app_name" {
  description = "Name of the Azure Web App."
  type        = string
  default     = "TestTFWebApp"
}

variable "private_endpoint_name" {
  description = "Name of the private endpoint."
  type        = string
  default     = "TestTFPrivateEndpoint"
}

variable "private_link_service_connection_name" {
  description = "Name of the private link service connection inside the private endpoint."
  type        = string
  default     = "TestTFPrivateLinkServiceConnection"
}

variable "web_app_virtual_network_name" {
  description = "Name of the dedicated virtual network for the Web App private endpoint stack."
  type        = string
  default     = "TestTFWebAppVNet"
}

variable "web_app_virtual_network_cidr" {
  description = "CIDR range for the dedicated Web App virtual network."
  type        = string
  default     = "10.30.0.0/16"
}

variable "web_app_private_endpoints_subnet_name" {
  description = "Name of the dedicated private endpoints subnet for the Web App stack."
  type        = string
  default     = "TestTFWebAppPrivateEndpointsSubnet"
}

variable "web_app_private_endpoints_subnet_cidr" {
  description = "CIDR range for the dedicated private endpoints subnet for the Web App stack."
  type        = string
  default     = "10.30.1.0/24"
}

variable "private_dns_record_name" {
  description = "Name of the private DNS A record. Kept lowercase because DNS labels are conventionally lowercase."
  type        = string
  default     = "testtfwebapprecord"
}

variable "user_assigned_identity_name" {
  description = "Name of the user-assigned managed identity."
  type        = string
  default     = "TestTFIdentity"
}

variable "federated_identity_credential_name" {
  description = "Name of the federated identity credential."
  type        = string
  default     = "TestTFFederatedCredential"
}

variable "federated_issuer" {
  description = "OIDC issuer URL for the federated identity credential."
  type        = string
  default     = null
  nullable    = true
}

variable "federated_subject" {
  description = "OIDC subject for the federated identity credential."
  type        = string
  default     = null
  nullable    = true
}

variable "federated_audiences" {
  description = "OIDC audiences for the federated identity credential."
  type        = list(string)
  default     = []
}

variable "storage_container_name" {
  description = "Name of the blob container created in the primary storage account for RBAC scope testing. Kept lowercase to satisfy Azure Storage container naming requirements."
  type        = string
  default     = "testtfcontainer"
}

variable "enable_rbac_assignments" {
  description = "Whether to create role assignments for the user-assigned managed identity. Requires the Terraform Azure principal to have Microsoft.Authorization/roleAssignments/write permissions."
  type        = bool
  default     = false
}

variable "recovery_services_vault_name" {
  description = "Name of the Recovery Services vault."
  type        = string
  default     = "TestTFRecoveryVault"
}

variable "backup_policy_name" {
  description = "Name of the VM backup policy."
  type        = string
  default     = "TestTFBackupPolicy"
}

variable "backup_time_utc" {
  description = "UTC time for the daily backup schedule in HH:MM format."
  type        = string
  default     = "23:00"
}

variable "backup_retention_daily_count" {
  description = "Number of daily backups to retain."
  type        = number
  default     = 7
}

variable "storage_account_prefix" {
  description = "Lowercase prefix for the storage account name. Must keep the final name under 24 characters."
  type        = string
  default     = "tfcfree"

  validation {
    condition     = can(regex("^[a-z0-9]{3,15}$", var.storage_account_prefix))
    error_message = "storage_account_prefix must be 3-15 lowercase alphanumeric characters."
  }
}

variable "diagnostics_storage_account_prefix" {
  description = "Lowercase prefix for the diagnostics storage account name. Must keep the final name under 24 characters."
  type        = string
  default     = "tfcdiag"

  validation {
    condition     = can(regex("^[a-z0-9]{3,15}$", var.diagnostics_storage_account_prefix))
    error_message = "diagnostics_storage_account_prefix must be 3-15 lowercase alphanumeric characters."
  }
}

variable "tags" {
  description = "Optional tags applied to created resources."
  type        = map(string)
  default = {
    managed_by = "terraform"
    workload   = "test"
  }
}
