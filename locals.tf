locals {
  tenant_id   = var.tenant_id != null ? var.tenant_id : data.azurerm_client_config.current.tenant_id
}