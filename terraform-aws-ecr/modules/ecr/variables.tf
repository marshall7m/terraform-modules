variable "create_repo" {
  description = "Determines if ECR repo should be created"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Tags to attach to all resources"
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "Name of ECR repo"
  type        = string
  default     = null
}

variable "ecr_tags" {
  description = "Tags to attach to the ECR repo"
  type        = map(any)
  default     = {}
}

variable "ecr_repo_url_to_ssm" {
  description = "Determines if the repo url should be saved in SSM Parameter Store"
  type        = bool
  default     = false
}

variable "ssm_key" {
  description = "SSM Parameter Store key for ECR repo url"
  type        = string
  default     = null
}

variable "ssm_tags" {
  description = "Tags to attach to the ECR repo url SSM parameter"
  type        = map(any)
  default     = {}
}

variable "codebuild_access" {
  description = "Determines if CodeBuild services are allowed to pull images from the ECR repo"
  type        = bool
  default     = false
}