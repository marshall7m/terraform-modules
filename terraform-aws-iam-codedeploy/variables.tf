variable "role_name" {
  description = "Codedeploy IAM role name"
  type        = string
  default     = ""
}

variable "role_path" {
  description = "Path of codedeploy IAM role"
  type        = string
  default     = "/"
}

variable "permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for the codedeploy role"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to codedeploy role"
  type        = map(string)
  default     = {}
}

variable "custom_role_policy_arns" {
    default = []
}

#### DEFAULT POLICIES ####

variable "attach_aws_code_deploy_role" {
    default = false
}

variable "attach_s3_access" {
    default = false
}

variable "s3_resource_arns" {
    default = []
}

variable "attach_ssm_access" {
    default = false
}

variable "ssm_resource_arns" {
    default = []
}

variable "kms_resource_arns" {
    default = []
}


