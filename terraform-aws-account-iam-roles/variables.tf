#### ADMIN - ROLE ####
variable "admin_role_cross_account_arns" {
  default = []
}

variable "admin_role_name" {
  default = "cross-account-admin-access"
}

variable "admin_role_path" {
  default = "/"
}

variable "admin_role_max_session_duration" {
  default = 3600
  type = number
}

variable "admin_role_description" {
  default = "Assumable role that allows trusted entities to perform administrative actions"
}

variable "admin_role_force_detach_policies" {
  type = bool
  default = false
}

variable "admin_role_permissions_boundary" {
  type = string
  default = ""
}

variable "admin_role_requires_mfa" {
  type = bool
  default = true
}

variable "admin_role_mfa_age" {
  type = number
  default = 86400
}

variable "admin_role_tags" {
  type = map(string)
  default = {}
}

variable "admin_allowed_resources" {
  type = list(string)
  default = null
}

variable "admin_allowed_actions" {
  type = list(string)
  default = null
}

variable "admin_role_conditions" {
  type = list(object({
    test = string
    variable = string
    values = list(string)
  }))
  default = []
}

variable "admin_role_statements" {
  description = "IAM policy statements to add to the policy that can be attached to the admin role"
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
  type = list(any)
  default = null
}

variable "admin_policy_name" {
  type = string
  default = "cross-account-admin-access-policy"
}

variable "admin_policy_description" {
  type = string
  default = "Assumable admin role policy"
}

variable "admin_policy_path" {
  default = "/"
}

variable "custom_admin_role_policy_arns" {
  type = list(string)
  default = []
}


#### DEV - ROLE ####
variable "dev_role_cross_account_arns" {
  default = []
}

variable "dev_role_name" {
  default = "cross-account-dev-access"
}

variable "dev_role_path" {
  default = "/"
}

variable "dev_role_max_session_duration" {
  default = 3600
  type = number
}

variable "dev_role_description" {
  default = "Assumable role that allows trusted entities to perform read/list/write actions"
}

variable "dev_role_force_detach_policies" {
  type = bool
  default = false
}

variable "dev_role_permissions_boundary" {
  type = string
  default = ""
}

variable "dev_role_requires_mfa" {
  type = bool
  default = true
}

variable "dev_role_mfa_age" {
  type = number
  default = 86400
}

variable "dev_role_tags" {
  type = map(string)
  default = {}
}

variable "dev_allowed_resources" {
  type = list(string)
  default = null
}

variable "dev_allowed_actions" {
  type = list(string)
  default = null
}

variable "dev_role_conditions" {
  type = list(object({
    test = string
    variable = string
    values = list(string)
  }))
  default = []
}

variable "dev_role_statements" {
  description = "IAM policy statements to add to the policy that can be attached to the dev role"
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
  type = list(any)
  default = null
}

variable "dev_policy_name" {
  type = string
  default = "cross-account-dev-access-policy"
}

variable "dev_policy_description" {
  type = string
  default = "Assumable dev role policy"
}

variable "dev_policy_path" {
  default = "/"
}

variable "custom_dev_role_policy_arns" {
  type = list(string)
  default = []
}


#### READ - ROLE ####
variable "read_role_cross_account_arns" {
  default = []
}

variable "read_role_name" {
  default = "cross-account-read-access"
}

variable "read_role_path" {
  default = "/"
}

variable "read_role_max_session_duration" {
  default = 3600
  type = number
}

variable "read_role_description" {
  default = "Assumable role that allows trusted entities to perform read/list actions"
}

variable "read_role_force_detach_policies" {
  type = bool
  default = false
}

variable "read_role_permissions_boundary" {
  type = string
  default = ""
}

variable "read_role_requires_mfa" {
  type = bool
  default = true
}

variable "read_role_mfa_age" {
  type = number
  default = 86400
}

variable "read_role_tags" {
  type = map(string)
  default = {}
}

variable "read_allowed_resources" {
  type = list(string)
  default = null
}

variable "read_allowed_actions" {
  type = list(string)
  default = null
}

variable "read_role_conditions" {
  type = list(object({
    test = string
    variable = string
    values = list(string)
  }))
  default = []
}

variable "read_role_statements" {
  description = "IAM policy statements to add to the policy that can be attached to the read role"
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
  type = list(any)
  default = null
}

variable "read_policy_name" {
  type = string
  default = "cross-account-read-access-policy"
}

variable "read_policy_description" {
  type = string
  default = "Assumable read role policy"
}

variable "read_policy_path" {
  default = "/"
}

variable "custom_read_role_policy_arns" {
  type = list(string)
  default = []
}



#### TF_PLAN - ROLE ####
variable "tf_plan_role_cross_account_arns" {
  default = []
}

variable "tf_plan_role_name" {
  default = "cross-account-tf-plan-access"
}

variable "tf_plan_role_path" {
  default = "/"
}

variable "tf_plan_role_max_session_duration" {
  default = 3600
  type = number
}

variable "tf_plan_role_description" {
  default = "Assumable role that allows trusted CI services to perform defined read/list actions"
}

variable "tf_plan_role_force_detach_policies" {
  type = bool
  default = false
}

variable "tf_plan_role_permissions_boundary" {
  type = string
  default = ""
}

variable "tf_plan_role_tags" {
  type = map(string)
  default = {}
}

variable "tf_plan_allowed_resources" {
  type = list(string)
  default = null
}

variable "tf_plan_allowed_actions" {
  type = list(string)
  default = null
}

variable "tf_plan_role_conditions" {
  type = list(object({
    test = string
    variable = string
    values = list(string)
  }))
  default = []
}

variable "tf_plan_role_statements" {
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
  type = list(any)
  default = null
}

variable "tf_plan_policy_name" {
  type = string
  default = "cross-account-tf-plan-access-policy"
}

variable "tf_plan_policy_description" {
  type = string
  default = "Assumable tf_plan role policy"
}

variable "tf_plan_policy_path" {
  default = "/"
}

variable "custom_tf_plan_role_policy_arns" {
  type = list(string)
  default = []
}


#### tf_apply - ROLE ####
variable "tf_apply_role_cross_account_arns" {
  default = []
}

variable "tf_apply_role_name" {
  default = "cross-account-tf-apply-access"
}

variable "tf_apply_role_path" {
  default = "/"
}

variable "tf_apply_role_max_session_duration" {
  default = 3600
  type = number
}

variable "tf_apply_role_description" {
  default = "Assumable role that allows trusted CI services to perform defined read/list/write actions"
}

variable "tf_apply_role_force_detach_policies" {
  type = bool
  default = false
}

variable "tf_apply_role_permissions_boundary" {
  type = string
  default = ""
}

variable "tf_apply_role_tags" {
  type = map(string)
  default = {}
}

variable "tf_apply_allowed_resources" {
  type = list(string)
  default = null
}

variable "tf_apply_allowed_actions" {
  type = list(string)
  default = null
}

variable "tf_apply_role_conditions" {
  type = list(object({
    test = string
    variable = string
    values = list(string)
  }))
  default = []
}

variable "tf_apply_role_statements" {
  description = "IAM policy statements to add to the policy that can be attached to the tf_apply role"
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
  type = list(any)
  default = null
}

variable "tf_apply_policy_name" {
  type = string
  default = "cross-account-tf-apply-access-policy"
}

variable "tf_apply_policy_description" {
  type = string
  default = "Assumable tf_apply role policy"
}

variable "tf_apply_policy_path" {
  default = "/"
}

variable "custom_tf_apply_role_policy_arns" {
  type = list(string)
  default = []
}