# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "arg" {
  name     = var.rg_name
  location = var.location
}

# Data source to get Azure client configuration
data "azurerm_client_config" "current" {}

# Create a Key Vault
resource "azurerm_key_vault" "azureKeyVault" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.arg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  # The SKU name for the Key Vault. 
  # Options are "standard" or "premium".
  # - "standard" is suitable for most use cases and is more cost-effective.
  # - "premium" offers HSM-backed keys and potentially higher performance.
  sku_name = "standard"

}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id            = azurerm_key_vault.azureKeyVault.id
  tenant_id               = azurerm_client_config.current.tenant_id
  object_id               = azurerm_client_config.current.object_id
  secret_permissios       = ["Get", "List", "Set", "Delete"]
  
}