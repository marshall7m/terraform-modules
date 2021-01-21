variable "common_tags" {
    description = "Tags to add to all resources"
    type = map(string)
    default = {}
}

#### IAM-ROLE ####

variable "region" {
    description = "AWS region where the Codebuild project should reside"
    type = string
    default = null
}

variable "account_id" {
    description = "The AWS account that the CodeBuild project will be created in"
    type = number
    default = null
}

variable "assumable_role_arns" {
    description = "AWS role ARNs the CodeBuild project is allowed to assume"
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
  default = "Allows CodeBuild service to perform actions on your behalf"
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

#### PROJECT ####

# See for reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project

variable "name" {
    description = "Build name (used also for codebuild policy name)"
    type = string
    default = null
}

variable "description" {
    description = "CodeBuild project description"
    type = string
    default = null
}

variable "build_timeout" {
    description = "Minutes till build run is timed out"
    type = string
    default = null
}

variable "webhook_filter_groups" {
    description = "Webhook filter groups to apply to the build. (only used when var.builds is null)"
    type = list(list(object({
        pattern = string
        type = string
        exclude_matched_pattern = optional(bool)
    })))
    default = []
}

variable "build_source" {
    description = <<EOF
Source configuration that will be loaded into the CodeBuild project's buildspec
see for more info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#argument-reference
    EOF
    type = object({
        type = optional(string)
        auth = optional(object({
            type = optional(string)
            resource = optional(string)
        }))
        buildspec = optional(string)
        git_clone_depth = optional(string)
        git_submodules_config = optional(object({
            fetch_submodules = bool
        }))
        insecure_ssl = optional(bool)
        location = optional(string)
        report_build_status = optional(bool)
    })
}

variable "source_auth_ssm_param_name" {
    description = "AWS SSM Parameter Store key used to retrieve the sensitive build source authorization value (e.g. Github personal token for OAUTH authorization type)"
    type = string
    default = null
}

variable "source_user_name" {
    description = "Source Bitbucket user name (required only for Bitbucket)"
    type = string
    default = null
}

variable "source_token" {
    description = "App password (Bitbucket source) or personal access token (Github/Github Enterprise)"
    type = string
    default = null
    sensitive = true
}

variable "build_tags" {
    description = "Tags to attach to the CodeBuild project"
    type = map
    default = {}
}

variable "artifacts" {
    description = <<EOF
Build project's primary output artifacts configuration
see for more info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#argument-reference
EOF
    type = object({
        type = string
        artifact_identifier = optional(string)
        encryption_disabled = optional(bool)
        override_artifact_name = optional(bool)
        location = optional(string)
        name = optional(string)
        namespace_type = optional(string)
        packaging = optional(string)
        path = optional(string)

    })
}

variable "cache" {
    description = "Build project's cache storage configurations"
    type = object({
        type = optional(string)
        location = optional(string)
        modes = optional(list(string))
    })
    default = {}
}

variable "environment" {
    description = <<EOF
Build project's environment configurations
see for more info: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project#argument-reference
EOF
    type = object({
        compute_type = string
        image        = string
        type                        = string
        image_pull_credentials_type = optional(string)
        environment_variables = optional(list(object({
            name = optional(string)
            value = optional(string)
            type = optional(string)
        })))
        priviledged_mode = optional(bool)
        certificate = optional(string)
        registry_credentials = optional(object({
            credential = string
            credential_provider = string
        }))
    })
}

variable "secondary_artifacts" {
    description = "Build project's secondary output artifacts configuration"
    type = map
    default = null
}

variable "codepipeline_artifact_bucket_name" {
    description = "Associated Codepipeline artifact bucket name"
    type = string
    default = null
}

variable "codepipeline_arn" {
    description = "Associated Codepipeline ARN"
    type = string
    default = null
}

variable "s3_logs" {
    description = "Determines if S3 logs should be enabled"
    type = bool
    default = false
}

variable "s3_log_key" {
    description = "Bucket path where the build project's logs will be stored (don't include bucket name)"
    type = string
    default = null
}

variable "s3_log_bucket" {
    description = "Name of S3 bucket where the build project's logs will be stored"
    type = string
    default = null
}

variable "s3_log_encryption_disabled" {
    description = "Determines if encryption should be used for the build project's S3 logs"
    type = bool
    default = false
}

variable "cw_logs" {
    description = "Determines if CloudWatch logs should be enabled"
    type = bool
    default = true
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

variable "role_arn" {
    description = "Existing IAM role ARN to attach to CodeBuild project"
    type = string
    default = null
}