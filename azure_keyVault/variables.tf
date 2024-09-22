variable rg_name {
  type        = string
  default     = "rg"
  description = "resource group name"
}

variable location {
  type        = string
  default     = "eu-west-1"
  description = "region"
}

#############################
# Azure Key Vault variables #
#############################

variable "kv_name" {
  type        = string
  description = "The name of the Azure Key Vault"
  default = "akv"
}

variable "secrets" {
  type = map(object({
    value = string
  }))
  description = "Define Azure Key Vault secrets"
  default = {}
}

variable "policies" {
  type = map(object({
    tenant_id               = string
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    storage_permissions     = list(string)
  }))
  description = "Define a Azure Key Vault access policy"
  default = {}
}