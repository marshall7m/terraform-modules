variable "trigger_branch" {
    default = "master"
}

variable "resource_prefix" {
    type = string
    default = ""
}

variable "resource_suffix" {
    type = string
    default = ""
}

variable "terragrunt_version" {
    type = string
    default = "0.25.4"
}

variable "terraform_version" {
    type = string
    default = "0.13.5"
}

variable "source_type" {
    type = string
    default = null
}

variable "target_paths" {
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

variable "builds" {
    type = any
/*
TODO: 
change to below when issue: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional map input
type = list(object({
    name = string
    trigger_branch = string
    target_paths = list
    source_type = bool
    commands = list
    service_role_arn = string
    environment_variables = {}
}))
*/
}