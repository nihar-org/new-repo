# ig-tf-test

Minimal Terraform configuration for Terraform Cloud that creates a basic Azure resource:

- 2 resource groups
- 1 standard LRS storage account
- 1 diagnostics storage account
- 1 virtual network (`10.0.0.0/16`)
- 6 subnets (`vm`, `functions`, `private_endpoints`, `private_link_service`, `aks_nodes`, `aks_pods`)
- 1 network security group with 2 rules
- 1 route table with 1 route
- 3 subnet associations
- 1 network interface
- 1 Standard Load Balancer for Private Link Service
- 1 managed disk
- 1 optional managed disk attachment
- 1 Log Analytics workspace
- 1 AKS cluster
- 1 AKS user node pool
- 1 Azure SQL database
- 1 Azure SQL server
- 2 App Service plans
- 1 Azure Function App
- 1 optional Azure Function definition
- 1 optional Azure Web App
- 1 user-assigned managed identity
- 1 optional federated identity credential
- 1 optional TestTF virtual network
- 1 optional TestTF network interface
- 1 optional TestTF network security group
- 1 optional TestTF virtual machine
- 1 optional TestTF virtual machine extension
- 4 monitor diagnostic settings
- 4 private DNS zones
- 1 optional private DNS A record
- 4 private DNS zone virtual network links
- 3 private endpoints
- 1 Private Link Service
- 1 optional private endpoint with private link service connection
- 1 optional dedicated Web App VNet and private endpoints subnet
- 1 Recovery Services vault
- 1 VM backup policy
- 1 optional protected VM backup relationship
- 1 Management Group
- 1 Key Vault
- 1 optional custom role definition
- 1 Shared Image Gallery
- 1 Shared Image

This should work in an empty Azure subscription as long as the Terraform Cloud workspace has Azure credentials with permission to create resources.

This repo is set up for a VCS-driven Terraform Cloud workspace, so it does not use a `cloud` block in Terraform.

## Files

- `versions.tf`: Terraform and provider version requirements
- `providers.tf`: provider configuration
- `resource_groups.tf`: primary and secondary resource groups
- `storage.tf`: random suffix and storage account
- `network.tf`: virtual network, subnets, NSG, route table, NIC, private endpoints, private link service, load balancer, and private DNS
- `compute.tf`: managed disk
- `platform_services.tf`: AKS, SQL, management group, key vault, role definition, and image resources
- `app_services.tf`: App Service plans, Function App, and optional Web App/private endpoint resources
- `identity.tf`: user-assigned identity and optional federated identity credential
- `function_app/`: file-based Azure Function definition content
- `testtf_vm.tf`: optional TestTF network and VM stack
- `monitoring.tf`: diagnostics storage account targets and monitor diagnostic settings
- `backup.tf`: Recovery Services vault and VM backup policy
- `rbac.tf`: Azure role assignments
- `variables.tf`: input variables with safe defaults
- `outputs.tf`: useful output values

## Before you run

1. Create a Terraform Cloud workspace connected to this repository.
2. In the Terraform Cloud workspace, add these environment variables:
   - `ARM_CLIENT_ID`
   - `ARM_CLIENT_SECRET`
   - `ARM_SUBSCRIPTION_ID`
   - `ARM_TENANT_ID`
3. Optionally set `enable_rbac_assignments = true` if the Terraform Cloud Azure principal has permission to create role assignments. When enabled, Terraform creates RBAC assignments for the user-assigned managed identity against the resource group, Key Vault, virtual network, storage account, and a blob container created in the primary storage account.
4. Optionally add these Terraform variables in the workspace if you want Terraform to create the federated identity credential:
   - `federated_issuer`
   - `federated_subject`
   - `federated_audiences`
5. Add this Terraform variable in the workspace for platform services:
   - `sql_administrator_login_password`
6. Optionally add this Terraform variable if you want Terraform to create the custom role definition:
   - `role_definition_scope_id`
7. Optionally set `enable_testtf_vm_stack = true` if you want Terraform to create the differently cased `TestTF...` VNet, NIC, NSG, VM, and VM extension resources.
8. Queue a plan in Terraform Cloud.

## Notes

- The storage account name must be globally unique. This config appends a random suffix automatically.
- The diagnostics storage account also appends the same random suffix automatically.
- The Azure SQL server name also appends the same random suffix automatically to avoid name collisions across regions.
- User-controlled resource names now default to PascalCase wherever Azure allows it.
- Lowercase-only exceptions remain for storage account names, SQL server names, Key Vault names, AKS DNS/node pool names, and DNS record/domain-style names where the platform or naming conventions require lowercase.
- The blob container name is also lowercase-only because Azure Storage container names must be lowercase.
- `eastus` is used by default, but you can change `location` if your subscription requires a different region.
- A second resource group is created in `westus2` by default via `secondary_location`.
- Azure SQL defaults to `westus2` via `sql_location` because some subscriptions cannot provision SQL in `eastus`.
- The primary VNet now gets private endpoints and Azure private DNS zones for the storage account, Key Vault, and SQL server.
- A standalone Azure Private Link Service is also created on a dedicated subnet behind a Standard internal load balancer frontend.
- When `enable_testtf_vm_stack = true`, Terraform protects that VM with the Recovery Services vault policy.
- Set `enable_testtf_vm_data_disk_attachment = true` only if the optional TestTF VM can be updated in place to attach the managed disk.
- The VNet, subnets, NSG, route table, network interface, and private DNS resources are created in the primary resource group and primary region by default.
- The federated identity credential is optional. Terraform creates it only when issuer, subject, and at least one audience are provided.
- The `TestTF...` VM stack is optional and disabled by default so routine runs are not forced to create a VM.
- The optional `TestTF...` VM stack defaults to `Standard_D2s_v3` because both `Standard_B1s` and `Standard_B1ms` hit eastus capacity restrictions during testing.
- The Function App uses a `Y1` Linux Consumption plan.
- The Function App does not enable `WEBSITE_RUN_FROM_PACKAGE` by default because this repo does not publish a zip package artifact during Terraform runs.
- The Web App uses a separate `B1` dedicated App Service plan because regular Web Apps cannot run on `Y1`.
- The Web App stack defaults to `westus2` to avoid the App Service capacity issues seen in `eastus`.
- The Web App stack uses a dedicated `westus2` VNet and private endpoints subnet so the private endpoint stays in the same region as the Web App plan.
- The sample Azure Function definition is optional and disabled by default because the Azure host runtime repeatedly rejected creation through `azurerm_function_app_function`.
- Terraform now waits `90s` by default after creating the Function App before creating the sample function definition.
- The Web App, private endpoint, and private DNS A record are optional and enabled only when the dedicated Web App plan path is desired.
- Existing resources are reused when they already exist in this configuration, including the backup policy, private DNS zone, private DNS zone virtual network link, managed disk, subnets, and route table.
- The backup policy is defined independently; it does not protect any VM until you associate a VM with the vault and policy.
- The role assignments are optional. Terraform creates them only when all RBAC-related variables are provided.
- The custom role definition is optional. Terraform creates it only when `role_definition_scope_id` is provided.

## Temporary CLI Hookup

For one-off Terraform CLI state operations against the same Terraform Cloud workspace, you can create a local ignored file named `cloud.auto.tf` from `cloud.auto.tf.example` and fill in the Terraform Cloud organization and workspace name.

Example flow:

1. Copy `cloud.auto.tf.example` to `cloud.auto.tf`.
2. Replace `REPLACE_WITH_TFC_ORG` and `REPLACE_WITH_TFC_WORKSPACE`.
3. Run `terraform login` if needed.
4. Run `terraform init`.
5. Run commands like `terraform state list` or `terraform state rm ...`.
6. Delete `cloud.auto.tf` when you are done.

`cloud.auto.tf` is gitignored so it stays local.
