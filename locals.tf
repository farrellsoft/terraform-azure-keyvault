locals {
  tenant_id   = var.tenant_id != null ? var.tenant_id : data.azurerm_client_config.current.tenant_id

  network_access = {
    bypass                  = var.network_access.allow_azure ? "AzureServices" : "None"
    default_action          = var.network_access.allow_public ? "Allow" : "Deny"
    ip_rules                = length(var.network_access.ip_rules) > 0 ? var.network_access.ip_rules : null
    virtual_network_subnets = length(var.network_access.virtual_network_subnets) > 0 ? var.network_access.virtual_network_subnets : null
  }
}