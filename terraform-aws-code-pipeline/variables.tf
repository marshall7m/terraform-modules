variable "account_id" {
  description = "AWS account id"
  type = number
}

variable "common_tags" {
    description = "Tags to add to all resources"
    type = map(string)
    default = {}
}

#### CODEPIPELINE ####

variable "role_arn" {
  description = "Pre-existing IAM role ARN to use for the CodePipeline"
  type = string
  default = null
}

variable "pipeline_name" {
  description = "Pipeline name"
  type = string
}

variable "create_artifact_bucket" {
  description = "Determines if a S3 bucket should be created for storing the pipeline's artifacts"
  type = bool
  default = false
}

variable "artifact_bucket_name" {
  description = "Name of the artifact S3 bucket to be created or the name of a pre-existing bucket name to be used for storing the pipeline's artifacts"
  default = null
}

variable "artifact_bucket_force_destroy" {
  description = "Determines if all bucket content will be deleted if the bucket is deleted (error-free bucket deletion)"
  type = bool
  default = false
}

variable "arifact_bucket_tags" {
  description = "Tags to attach to provisioned S3 bucket"
  type = map(string)
  default = {}
}

variable "stages" {
  description = "List of pipeline stages (see: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)"
  type = any
}

variable "pipeline_tags" {
  description = "Tags to attach to the pipeline"
  type = map(string)
  default = {}
}


#### CODEPIPELINE-IAM ####

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
  default = "Allows CodePipeline service to assume cross-account service roles"
}

variable "role_force_detach_policies" {
  description = "Determines attached policies to the CodePipeline service roles should be forcefully detached if the role is destroyed"
  type = bool
  default = false
}

variable "role_permissions_boundary" {
  description = "Permission boundary policy ARN used for CodePipeline service role"
  type = string
  default = ""
}

variable "role_tags" {
  description = "Tags to add to CodePipeline service role"
  type = map(string)
  default = {}
}

#### KMS-IAM ####

variable "encrypt_artifacts" {
  description = "Determines if the Pipeline's artifacts will be encrypted via KMS"
  type = bool
  default = true
}

variable "kms_key_admin_arns" {
  description = "ARNs of entities that can perform administrative actions on the KMS key"
  type = list(string)
  default = []
}

variable "kms_key_arn" {
  description = "Pre-existing KMS key to use for encrypting CodePipeline artifacts at rest"
  type = string
  default = null
}

variable "kms_key_tags" {
  description = "Tags to attach to the KMS key"
  type = map(string)
  default = {}
}

variable "kms_alias" {
  description = "Alias for KMS key"
  default = null
}