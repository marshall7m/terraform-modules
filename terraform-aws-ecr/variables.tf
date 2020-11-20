variable "create_repo" {
  description = "Determines if ECR repo should be created"
  type    = bool
  default = false
}

variable "name" {
  description = "Name of ECR repo"
  default = null
}

variable "tags" {
  description = "Tags to attach to the ECR repo"
  default = {}
}

variable "ecr_repo_url_to_ssm" {
  description = "Determines if the repo url should be saved in SSM Parameter Store"
  default = false
}

variable "ssm_key" {
  description = "SSM Parameter Store key for ECR repo url"
  default = null
}

variable "ssm_tags" {
  description = "Tags to attach to the ECR repo url SSM parameter"
  default = {}
}