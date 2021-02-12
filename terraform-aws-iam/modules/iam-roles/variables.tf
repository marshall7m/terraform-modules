variable "create_role" {
  description = "Determines if role should be created"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Role name"
  type        = string
}

variable "role_path" {
  description = "Path to create policy"
  type        = string
  default     = "/"
}

variable "role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  type        = number
  default     = 3600
}

variable "role_description" {
  description = "Description for role"
  type        = string
  default     = ""
}

variable "role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "role_requires_mfa" {
  description = "Determines if MFA (Multi Factor Authentication) is required to assume the role"
  type        = bool
  default     = false
}

variable "role_mfa_age" {
  description = "Max seconds the MFA will be valid for"
  type        = number
  default     = 86400
}

variable "role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Tags to attach to the role (used for implicit terragrunt variable inheritance)"
  type        = map(string)
  default     = {}
}

variable "trusted_entities" {
  description = "AWS users/roles that are allowed to assume this role"
  type        = list(string)
  default     = []
}

variable "trusted_services" {
  description = "AWS services that are allowed to assume this role"
  type        = list(string)
  default     = []
}

variable "allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "statements" {
  description = "IAM policy statements for role permissions"
  type = list(object({
    effect    = string
    resources = list(string)
    actions   = list(string)
    conditions = optional(list(map(object({
      test     = string
      variable = string
      values   = list(string)
    }))))
  }))
  default = []
}

variable "policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = null
}

variable "policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = ""
}

variable "policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  type        = string
  default     = "/"
}

variable "custom_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}