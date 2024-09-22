policies = {
  "policy1" = {
    tenant_id               = ""
    object_id               = "your-object-id"
    key_permissions         = ["get", "list"]
    secret_permissions      = ["Get", "List", "Set", "Delete"]
    certificate_permissions = ["Get", "List", "Set", "Delete"]
    storage_permissions     = ["Get", "List", "Set", "Delete"]
  }

}
