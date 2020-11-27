#### GLOBAL-BUILD-PARAMETERS ####

variable "resource_prefix" {
  description = "Prefix to use for all resource names"
  type = string
  default = ""
}

variable "resource_suffix" {
  description = "Suffix to use for all resource names"
  default = ""
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

 variable "common_tags" {
     description = "Tags to attach to all builds"
     type = map
     default = null
 }

#### SINGLE-BUILD||DEFAULT-BUILD-PARAMETERS ####
 
variable "name" {
    description = "Build name (before adding var.resource_prefix and var.resource_suffix)"
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
    default = []
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

variable "tags" {
    type = map
    default = {}
}

variable "buildspec" {
    type = string
    default = "buildspec_tf_default.yml"
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

#### MULTI-BUILD-PARAMETERS ####

variable "builds" {
    type = any
    default = null

/*
TODO: 
change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional map input
type = list(object({
    name = string
    trigger_branch = string
    target_paths = list(string)
    source_type = string
    source_location = string
    git_clone_depth = string
    buildspec = string
    commands = list(string)
    service_role_arn = string
    artifacts = map(string)
    build_compute_type = string
    build_image = string
    build_type = string
    build_image_pull_credentials_type = string
    environment_variables = list(object({
        name = string
        value = string
        type = string
    }))
    cw_stream_name = string
    cw_group_name = string
    s3_log_path = string
    s3_log_encryption_disabled = bool
    tags = map(string)
    webhook_filter_groups = list(list(object({
        pattern = string
        type = string
        exclude_matched_pattern = bool
    })))
}))
*/
}