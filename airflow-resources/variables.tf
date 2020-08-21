locals {
  tags = {
        Environment = var.env
        Terraform = "true"
        Service = var.service
        Version = var.version_tag
    }
}

variable "env" {
    type = string
}

variable "version_tag" {
    type = string
}

variable "service" {
    default = "data_pipeline"
}
variable "s3_buckets_dict" {
    type = map
}

variable "glue_jobs_dict" {
    type = map
}

variable "glue_crawlers_dict" {
    type = map
}

variable "athena_queries_dict" {
    type = map
}

variable "athena_workgroups_dict" {
    type = map
}

