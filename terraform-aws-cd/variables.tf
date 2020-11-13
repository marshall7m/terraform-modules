variable "default_bucket" {
  default = ""
}

variable "global_tags" {
  default = {}
}

#### ECR ####

variable "ecr_base_domain" {
  default = ""
}

variable "ecr_tags" {
  default = {}
}

variable "ecr_repo_url_to_ssm" {
  default = false
}

variable "ssm_ecr_repo_url_name" {
  default = ""
}

variable "ssm_ecr_repo_url_tags" {
  default = {}
}

#### CODE-DEPLOY-APP ####

variable "create_cd_app" {
  default = false
}

variable "cd_app_name" {
  default = ""
}

variable "cd_app_compute_platform" {
  default = ""
}

#### CODE-DEPLOY-CONFIG ####


variable "create_cd_config" {
  default = false
}

variable "cd_config_name" {
  default = ""
}

variable "cd_config_traffic_routing_config" {
  default = {}
}

variable "cd_config_minimum_healthy_hosts" {
  default = {}
}

#### CODE-DEPLOY-GROUP ####

variable "create_cd_group" {
  default = false
}

variable "cd_group_name" {
  default = ""
}

variable "cd_group_deployment_style" {
  type = object({
    deployment_type = string
    deployment_option = string
  })
}

variable "cd_group_load_balancer_info" {
  default = {}
}

variable "cd_group_blue_green_deployment_config" {
  default = {}
}

variable "cd_group_role_arn" {
  default = ""
}

variable "cd_group_ec2_tag_set" {
  default = []
}

variable "cd_group_ec2_tag_filters" {
  default = {}
}

variable "cd_group_auto_rollback_configuration" {
  type = object({
    enabled = string
    events = list(string)
  })
}