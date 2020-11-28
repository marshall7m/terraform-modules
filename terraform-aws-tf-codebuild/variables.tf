
variable "resource_prefix" {
  description = "Prefix to use for all resource names"
  type = string
  default = ""
}

variable "resource_suffix" {
  description = "Suffix to use for all resource names"
  default = ""
}

variable "common_tags" {
    default = {}
}

#### IAM-ROLE ####

variable "cross_account_assumable_roles" {
    type = list(string)
    default = []
}

variable "role_path" {
  default = "/"
}

variable "role_max_session_duration" {
  default = 3600
  type = number
}

variable "role_description" {
  default = "Assumable role that allows trusted entities to perform administrative actions"
}

variable "role_force_detach_policies" {
  type = bool
  default = false
}

variable "role_permissions_boundary" {
  type = string
  default = ""
}

variable "role_tags" {
  type = map(string)
  default = {}
}

#### CODE-BUILD ####

variable "name" {
    description = "Build name (before adding var.resource_prefix and var.resource_suffix)"
    type = string
    default = null
}

variable "terragrunt_version" {
    description = "Terragrunt version to download within the build's respective buildspec.yml"
    type = string
    default = "0.25.4"
}

variable "terraform_version" {
    description =  "Terraform version to download within the build's respective buildspec.yml"
    type = string
    default = "0.13.5"
}

variable "webhook_filter_groups" {
    description = "Webhook filter groups to apply to the build. (only used when var.builds is null)"
    type = list(list(object({
        pattern = string
        type = string
        exclude_matched_pattern = bool
    })))
    default = null
}

variable "source_type" {
    type = string
    default = null
}

variable "target_paths" {
    type = list
    default = null
}

variable "commands" {
    type = list
    default = null
}

variable "build_tags" {
    type = map
    default = {}
}

variable "buildspec" {
    type = string
}

variable "artifacts" {
    type = map
    default = null
}

variable "build_compute_type" {
    type = string
    default = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
    type = string
    default = "aws/codebuild/standard:4.0"
}

variable "build_type" {
    type = string
    default = "LINUX_CONTAINER"
}

variable "build_image_pull_credentials_type" {
    type = string
    default = "CODEBUILD"
}

variable "s3_log_path" {
    type = string
    default = null
}

variable "s3_log_encryption_disabled" {
    type = bool
    default = false
}

variable "cw_group_name" {
    type = string
    default = null
}

variable "cw_stream_name" {
    type = string
    default = null
}

variable "service_role_arn" {
    type = string
    default = null
}

variable "environment_variables" {
    type = list(object({
        name = string
        value = string
        type = string
    }))
    default = []
}