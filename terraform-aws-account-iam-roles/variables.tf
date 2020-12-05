#### ADMIN - ROLE ####
variable "admin_role_cross_account_arns" {
  description = "List of ARNs allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "admin_role_name" {
  description = "Role name"
  default     = "cross-account-admin-access"
}

variable "admin_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "admin_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "admin_role_description" {
  default = "Cross-account assumable role"
}

variable "admin_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "admin_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "admin_role_requires_mfa" {
  description = "Determines if MFA (Multi Factor Authentication) is required to assume the role"
  type        = bool
  default     = true
}

variable "admin_role_mfa_age" {
  description = "Max seconds the MFA will be valid for"
  type        = number
  default     = 86400
}

variable "admin_role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "admin_allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "admin_allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "admin_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "admin_statements" {
  description = "IAM policy statements used to define the permission for the role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "admin_policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = "cross-account-admin-access"
}

variable "admin_policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = "Assumable admin role policy"
}

variable "admin_policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  default     = "/"
}

variable "custom_admin_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

#### DEV - ROLE ####

variable "dev_role_cross_account_arns" {
  description = "List of ARNs allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "dev_role_name" {
  description = "Role name"
  default     = "cross-account-dev-access"
}

variable "dev_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "dev_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "dev_role_description" {
  default = "Cross-account assumable role"
}

variable "dev_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "dev_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "dev_role_requires_mfa" {
  description = "Determines if MFA (Multi Factor Authentication) is required to assume the role"
  type        = bool
  default     = true
}

variable "dev_role_mfa_age" {
  description = "Max seconds the MFA will be valid for"
  type        = number
  default     = 86400
}

variable "dev_role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "dev_allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "dev_allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "dev_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "dev_statements" {
  description = "IAM policy statements used to define the permission for the role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "dev_policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = "cross-account-dev-access"
}

variable "dev_policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = "Assumable dev role policy"
}

variable "dev_policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  default     = "/"
}

variable "custom_dev_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

#### READ - ROLE ####

variable "read_role_cross_account_arns" {
  description = "List of ARNs allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "read_role_name" {
  description = "Role name"
  default     = "cross-account-read-access"
}

variable "read_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "read_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "read_role_description" {
  default = "Cross-account assumable role"
}

variable "read_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "read_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "read_role_requires_mfa" {
  description = "Determines if MFA (Multi Factor Authentication) is required to assume the role"
  type        = bool
  default     = true
}

variable "read_role_mfa_age" {
  description = "Max seconds the MFA will be valid for"
  type        = number
  default     = 86400
}

variable "read_role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "read_allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "read_allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "read_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "read_statements" {
  description = "IAM policy statements used to define the permission for the role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "read_policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = "cross-account-read-access"
}

variable "read_policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = "Assumable read role policy"
}

variable "read_policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  default     = "/"
}

variable "custom_read_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

#### LIMITED-S3-READ-ROLE ####

variable "limited_s3_read_role_cross_account_arns" {
  description = "List of ARNs allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "limited_s3_read_role_name" {
  description = "Role name"
  default     = "cross-account-limited-s3-read-access"
}

variable "limited_s3_read_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "limited_s3_read_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "limited_s3_read_role_description" {
  default = "Cross-account assumable role"
}

variable "limited_s3_read_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "limited_s3_read_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "limited_s3_read_role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "limited_s3_read_allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "limited_s3_read_allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "limited_s3_read_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "limited_s3_read_statements" {
  description = "IAM policy statements used to define the permission for the role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "limited_s3_read_policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = "cross-account-limited-s3-read-access"
}

variable "limited_s3_read_policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = "Assumable limited-s3-read role policy"
}

variable "limited_s3_read_policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  default     = "/"
}

variable "custom_limited_s3_read_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "limited_s3_read_role_requires_mfa" {
  description = "Determines if MFA (Multi Factor Authentication) is required to assume the role"
  type        = bool
  default     = true
}

variable "limited_s3_read_role_mfa_age" {
  description = "Max seconds the MFA will be valid for"
  type        = number
  default     = 86400
}

#### TF_PLAN - ROLE ####

variable "tf_plan_role_cross_account_arns" {
  type    = list(string)
  default = []
}

variable "tf_plan_role_name" {
  default = "cross-account-tf-plan-access"
}

variable "tf_plan_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "tf_plan_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "tf_plan_role_description" {
  default = "Assumable role that allows trusted CI services to perform defined read/list actions"
}

variable "tf_plan_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "tf_plan_role_permissions_boundary" {
  type    = string
  default = ""
}

variable "tf_plan_role_tags" {
  type    = map(string)
  default = {}
}

variable "tf_plan_allowed_resources" {
  type    = list(string)
  default = null
}

variable "tf_plan_allowed_actions" {
  type    = list(string)
  default = null
}

variable "tf_plan_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "tf_plan_statements" {
  description = "IAM policy statements to add to the policy that can be attached to the tf_plan role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "tf_plan_policy_name" {
  type    = string
  default = "cross-account-tf-plan-access-policy"
}

variable "tf_plan_policy_description" {
  type    = string
  default = "Assumable tf_plan role policy"
}

variable "tf_plan_policy_path" {
  default = "/"
}

variable "custom_tf_plan_role_policy_arns" {
  type    = list(string)
  default = []
}


#### TF-APPLY-ROLE ####

variable "tf_apply_role_cross_account_arns" {
  description = "List of ARNs allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "tf_apply_role_name" {
  description = "Role name"
  default     = "cross-account-tf-apply-access"
}

variable "tf_apply_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "tf_apply_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "tf_apply_role_description" {
  default = "Cross-account assumable role"
}

variable "tf_apply_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "tf_apply_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "tf_apply_role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "tf_apply_allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "tf_apply_allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "tf_apply_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "tf_apply_statements" {
  description = "IAM policy statements used to define the permission for the role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "tf_apply_policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = "cross-account-tf-apply-access"
}

variable "tf_apply_policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = "Assumable tf-apply role policy"
}

variable "tf_apply_policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  default     = "/"
}

variable "custom_tf_apply_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

#### CD-ROLE ####

variable "cd_role_cross_account_arns" {
  description = "List of ARNs allowed to assume the role"
  type        = list(string)
  default     = []
}

variable "cd_role_name" {
  description = "Role name"
  default     = "cross-account-cd-access"
}

variable "cd_role_path" {
  description = "Path to create policy"
  default     = "/"
}

variable "cd_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default     = 3600
  type        = number
}

variable "cd_role_description" {
  default = "Cross-account assumable role"
}

variable "cd_role_force_detach_policies" {
  description = "Determines if policies attached to the role should be forcefully detached if the role is destroyed"
  type        = bool
  default     = false
}

variable "cd_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for role"
  type        = string
  default     = ""
}

variable "cd_role_tags" {
  description = "Tags to attach to the role"
  type        = map(string)
  default     = {}
}

variable "cd_allowed_resources" {
  description = "List of resources the role will be allowed to perform on"
  type        = list(string)
  default     = null
}

variable "cd_allowed_actions" {
  description = "List of actions the role will be allowed to perform"
  type        = list(string)
  default     = null
}

variable "cd_role_conditions" {
  description = "IAM trust policy conditions used to conditionally allow entities to assume the role"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "cd_statements" {
  description = "IAM policy statements used to define the permission for the role"
  /* 
 change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional condition map
  type = list(object({
    effect = string
    resources = list(string)
    actions = list(string)
    condition = list(map(object({
      test = string
      variable = string
      values = list(string)
    })))
  }))
*/
  type    = list(any)
  default = null
}

variable "cd_policy_name" {
  description = "Name of the IAM policy used for defining the role permissions"
  type        = string
  default     = "cross-account-cd-access"
}

variable "cd_policy_description" {
  description = "Description of the IAM policy used for defining the role permissions"
  type        = string
  default     = "Assumable cd role policy"
}

variable "cd_policy_path" {
  description = "Path of the IAM policy used for defining the role permissions"
  default     = "/"
}

variable "custom_cd_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}