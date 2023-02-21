
variable application {
  type = string
  validation {
    condition     = length(var.application) > 3
    error_message = "${var.application} must be a minimum of three (3) characters."
  }
}

variable environment {
  type = string
  validation {
    condition     = length(var.environment) == 3
    error_message = "${var.environment} must be three (3) characters."
  }
}

variable instance_number {
  type = string
  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance_number))
    error_message = "${var.instance_number} must be three (3) numbers."
  }
  default   = "001"
}

variable location {
  type        = string
  description = "The location where the resources will be created."
}

variable resource_group_name {
  type        = string
  description = "The name of the resource group in which to create the resources."
}

// optional
variable tenant_id {
  type        = string
  description = "The tenant ID of the Azure Active Directory."
  default     = null
}

variable sku_name {
  type        = string
  description = "The name of the SKU to use for this Key Vault."
  default     = "standard"
  validation {
    condition     = can(regex("^(standard|premium)$", var.sku_name))
    error_message = "${var.sku_name} must be either 'standard' or 'premium'."
  }
}

variable network_access {
  type            = object({
    allow_azure             = optional(bool, true)
    allow_public            = optional(bool, false)
    ip_rules                = optional(list(string), [])
    virtual_network_subnets = optional(list(string), [])
    private_link_subnet_id  = optional(string, null)
  })
}

variable role_assignments {
  type        = list(object({
    role_definition_name = string,
    object_id            = string
  }))
  description = "A list of role assignments to apply to the Key Vault."
  default     = []
}