variable "default_bucket" {
  default = ""
}

variable "global_tags" {
  default = {}
}

#### CODE-DEPLOY-APP ####

variable "create_cd_app" {
  default = false
}

variable "cd_app_name" {}

variable "cd_app_compute_platform" {
  default = ""
}

#### CODE-DEPLOY-CONFIG ####


variable "create_cd_config" {
  default = false
}

variable "cd_config_name" {}

variable "cd_config_traffic_routing_config" {
  type    = any
  default = null
}

variable "cd_config_minimum_healthy_hosts" {
  type = object({
    type  = string
    value = number
  })
  default = null
}

#### CODE-DEPLOY-GROUP ####

variable "create_cd_group" {
  default = false
}

variable "cd_group_name" {}

variable "cd_group_deployment_style" {
  type = object({
    deployment_type   = string
    deployment_option = string
  })
}

variable "cd_group_load_balancer_info" {
  default = {}
}

variable "cd_group_blue_green_deployment_config" {
  default = {}
}

variable "cd_group_ec2_tag_set" {
  default = []
}

variable "cd_group_ec2_tag_filters" {
  type = list(map(string))
  default = {}
}

variable "cd_group_auto_rollback_configuration" {
  type = object({
    enabled = string
    events  = list(string)
  })
}

#### CODE-DEPLOY-ROLE-ARN ####

variable "cd_role_name" {
  default = null
}

variable "cd_role_arn" {
  default = null
}

variable "cd_role_path" {
  default = "/"
}

variable "cd_role_max_session_duration" {
  default = 3600
  type    = number
}

variable "cd_role_description" {
  default = "Assumable service role that allows trusted CodeDeploy services to perform necessary deployment actions"
}

variable "cd_role_force_detach_policies" {
  type    = bool
  default = false
}

variable "cd_role_permissions_boundary" {
  type    = string
  default = ""
}

variable "cd_role_tags" {
  type    = map(string)
  default = {}
}

variable "cd_allowed_resources" {
  type    = list(string)
  default = null
}

variable "cd_allowed_actions" {
  type    = list(string)
  default = null
}

variable "cd_role_conditions" {
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "cd_role_statements" {
  description = "IAM policy statements to add to the policy that can be attached to the cd role"
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
  type    = string
  default = null
}

variable "cd_policy_description" {
  type    = string
  default = "Assumable cd role policy"
}

variable "cd_policy_path" {
  default = "/"
}

variable "custom_cd_role_policy_arns" {
  type    = list(string)
  default = []
}