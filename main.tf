
data azurerm_client_config current {}

module "resource-naming" {
  source  = "app.terraform.io/Farrellsoft/resource-naming/azure"
  version = "0.0.8"
  
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
}

resource azurerm_role_assignment this {
  count           = length(var.role_assignments)

  scope                = azurerm_key_vault.this.id
  role_definition_name = var.role_assignments[count.index].role_definition_name
  principal_id         = var.role_assignments[count.index].object_id
}