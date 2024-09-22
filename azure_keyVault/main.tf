# Configure the Azure provider

provider "azurerm" {
  features {}
}

terraform {

  required_providers {
    
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.20.0"
    }

  }
    required_version = "~> 1.7"
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
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.tenant_id
  secret_permissions       = ["Get", "List", "Set", "Delete"]
  
}

# Generate a random password
resource "random_password" "password" {
  for_each    = var.secrets
  length      = 5
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2

  keepers = {
    name = each.key
  }
}

# Create an Azure Key Vault secrets
resource "azurerm_key_vault_secret" "secret" {
  for_each     = var.secrets
  key_vault_id = azurerm_key_vault.azureKeyVault.id
  name         = each.key
  value        = lookup(each.value, "value") != "" ? lookup(each.value, "value") : random_password.password[each.key].result
  tags         = var.tags
  depends_on = [
    azurerm_key_vault.key-vault,
    azurerm_key_vault_access_policy.default_policy,
  ]
}