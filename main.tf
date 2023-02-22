
data azurerm_client_config current {}

module "resource-naming" {
  source  = "app.terraform.io/Farrellsoft/resource-naming/azure"
  version = "1.0.1"
  
  application         = var.application
  environment         = var.environment
  instance_number     = var.instance_number
}

resource azurerm_key_vault this {
  name                        = module.resource-naming.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = local.tenant_id
  sku_name                    = var.sku_name

  enable_rbac_authorization   = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  network_acls {
    default_action             = local.network_access.default_action
    bypass                     = local.network_access.bypass
    ip_rules                   = local.network_access.ip_rules
    virtual_network_subnet_ids = local.network_access.virtual_network_subnets
  }
}

resource azurerm_role_assignment this {
  count           = length(var.role_assignments)

  scope                = azurerm_key_vault.this.id
  role_definition_name = var.role_assignments[count.index].role_definition_name
  principal_id         = var.role_assignments[count.index].object_id
}

// need private endpont
module "private-endpoint" {
  source  = "app.terraform.io/Farrellsoft/private-endpoint/azure"
  version = "1.0.3"
  count   = can(var.network_access.private_link_subnet_id) ? 1 : 0
 
  application         = var.application
  environment         = var.environment
  location            = var.location
  instance_number     = var.instance_number
  resource_group_name = var.resource_group_name
  subnet_id           = var.network_access.private_link_subnet_id
  resource_type       = "vault"

  private_connections = {
    keyVault = {
      resource_id       = azurerm_key_vault.this.id
      subresource_names = [
        "vault"
      ]
      private_dns_zone_id = var.network_access.private_dns_zone_id
    }
  }
}