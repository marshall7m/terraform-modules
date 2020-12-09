variable "common_tags" {
    description = "Tags to add to all resources"
    type = map(string)
    default = {}
}

#### IAM-ROLE ####

variable "cross_account_assumable_roles" {
    description = "Cross-account role ARNs that the CodeBuild project can assume"
    type = list(string)
    default = []
}

variable "role_path" {
  description = "Path to create policy"
  default = "/"
}

variable "role_max_session_duration" {
  description = "Max session duration (seconds) the role can be assumed for"
  default = 3600
  type = number
}

variable "role_description" {
  default = "Allows CodeBuild service to assume cross-account service roles"
}

variable "role_force_detach_policies" {
  description = "Determines attached policies to the CodeBuild service roles should be forcefully detached if the role is destroyed"
  type = bool
  default = false
}

variable "role_permissions_boundary" {
  description = "Permission boundary policy ARN used for CodeBuild service role"
  type = string
  default = ""
}

variable "role_tags" {
  description = "Tags to add to CodeBuild service role"
  type = map(string)
  default = {}
}

#### CODE-BUILD ####

# See for reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project

variable "name" {
    description = "Build name (used also for codebuild policy name)"
    type = string
    default = null
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

variable "build_source" {
    description = "Source configuration that will be loaded into the CodeBuild project's buildspec"
    type = map
}

variable "build_tags" {
    description = "Tags to attacht to the CodeBuild project"
    type = map
    default = {}
}

variable "artifacts" {
    description = "Build project's primary output artifacts configuration"
    type = map
}

variable "secondary_artifacts" {
    description = "Build project's secondary output artifacts configuration"
    type = map
    default = null
}

variable "build_compute_type" {
    description = "Build project's compute type (defaults to the smallest AWS Linux compute type)"
    type = string
    default = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
    description = "Build project's image (defaults to Linux)"
    type = string
    default = "aws/codebuild/standard:4.0"
}

variable "build_type" {
    description = "Build project's container type (defaults to Linux)"
    type = string
    default = "LINUX_CONTAINER"
}

variable "build_image_pull_credentials_type" {
    description = "Build project's image credentials type"
    type = string
    default = "CODEBUILD"
}

variable "s3_log_path" {
    description = "S3 path where the build project's logs will be stored"
    type = string
    default = null
}

variable "s3_log_encryption_disabled" {
    description = "Determines if encryption should be used for the build project's S3 logs"
    type = bool
    default = false
}

variable "cw_group_name" {
    description = "CloudWatch group name"
    type = string
    default = null
}

variable "cw_stream_name" {
    description = "CloudWatch stream name"
    type = string
    default = null
}

variable "service_role_arn" {
    description = "Build project service role"
    type = string
    default = null
}

variable "environment_variables" {
    description = "Environment variables to inject into the build project's buildspec"
    type = list(object({
        name = string
        value = string
        type = string
    }))
    default = []
}