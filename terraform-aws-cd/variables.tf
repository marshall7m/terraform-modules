#### CODE-DEPLOY-APP ####

variable "create_cd_app" {
  description = "Determines if a CodeDeploy App should be created"
  type = bool
  default = false
}

variable "cd_app_name" {
  description = "Name of the CodeDeploy App"
  type = string
  default = null
}

variable "cd_app_compute_platform" {
  description = "CodeDeploy App compute platform (Server | ECS | Lambda)"
  type = string
  default = null
}

#### CODE-DEPLOY-CONFIG ####

variable "create_cd_config" {
  description = "Determines if a custom deployment configuration should be created"
  type = bool
  default = false
}

variable "cd_config_name" {
  description = "Name of an existing or to be created deployment configuration"
  type = string
  default = null
}

variable "cd_config_traffic_routing_config" {
  description = "Type of traffic routing config to be applied during deployment rollout"
  type    = any
  default = null
}

variable "cd_config_minimum_healthy_hosts" {
  description = "Minimum amount of healthy hosts needed for a deployment"
  type = object({
    type  = string
    value = number
  })
  default = null
}

#### CODE-DEPLOY-GROUP ####

variable "create_cd_group" {
  description = "Determines if a deployment group should be created"
  type = bool
  default = false
}

variable "cd_group_name" {
  description = "Name of the deployment group to be created"
  type = string
  default = null
}

variable "cd_group_deployment_style" {
  description = "Determines if traffic should be routed behind a load balancer and the deployment style (blue/green or in-place)"
  type = object({
    deployment_type   = string
    deployment_option = string
  })
  default = {}
}

variable "cd_group_load_balancer_info" {
  description = "Load balancer configuration (optional)"
  type = any
  default = {}
}

variable "cd_group_blue_green_deployment_config" {
  description = "Blue/Green deployment configurations (optional)"
  type = any
  default = {}
}

variable "cd_group_ec2_tag_set" {
  description = "Set of ec2 tag filters used to determine the target deployment instances. Target instances must match atleast on filter per tag set"
  type = list(map(string))
  default = []
}

variable "cd_group_ec2_tag_filters" {
  description = "Individual ec2 tag filters to determine the target deployment instances"
  type = list(map(string))
  default = []
}

variable "cd_group_auto_rollback_configuration" {
  description = "Rollback configurations for deployment"
  type = object({
    enabled = string
    events  = list(string)
  })
  default = {}
}

#### CODE-DEPLOY-ROLE-ARN ####

variable "cd_role_name" {
  description = "CodeDeploy service role name"
  default = null
}

variable "cd_role_arn" {
  description = "Codedeploy service role ARN"
  type = string
  default = null
}

variable "cd_role_path" {
  description = "Path to create policy"
  type = string
  default = "/"
}

variable "cd_role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default = 3600
  type    = number
}

variable "cd_role_description" {
  description = "CodeDeploy service role description"
  type = string
  default = "Assumable service role that allows trusted CodeDeploy services to perform necessary deployment actions"
}

variable "cd_role_force_detach_policies" {
  description = "Determines attached policies to the Codedeploy service roles should be forcefully detached if the role is destroyed"
  type    = bool
  default = false
}

variable "cd_role_permissions_boundary" {
  description = "Permission boundary policy ARN used for CodeDeploy service role"
  type    = string
  default = null
}

variable "cd_role_tags" {
  description = "Tags to attach to the CodeDeploy service role"
  type    = map(string)
  default = {}
}

variable "cd_allowed_resources" {
  description = "List of AWS resources that CodeDeploy is allowed to perform defined actions on"
  type    = list(string)
  default = null
}

variable "cd_allowed_actions" {
  description = "List of AWS action that CodeDeploy is allowed to perform on defined resources"
  type    = list(string)
  default = null
}

variable "cd_role_conditions" {
  description = "List of condition blocks used to conditionally allow entities to assume the Codedeploy service role"
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
  description = "Name of the policy that will be attached to the CodeDeploy service role"
  type    = string
  default = null
}

variable "cd_policy_description" {
  description = "Description of the policy that will be attached to the CodeDeploy service role"
  type    = string
  default = "Assumable cd role policy"
}

variable "cd_policy_path" {
  description = "Path to create the policy that will be attached to the CodeDeploy service role"
  default = "/"
}

variable "custom_cd_role_policy_arns" {
  description = "Pre-existing IAM policies to attach to the CodeDeploy service role"
  type    = list(string)
  default = []
}