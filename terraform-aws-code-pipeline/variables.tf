variable "name" {
  type = string
}

variable "tags" {
  default = {}
}

variable "role_arn" {
  default = null
}

variable "artifact_store_bucket_name" {
  default = ""
}

variable "artifact_store_region" {
  default = ""
}

variable "s3_kms_key_arn" {
  default = null
}

variable "stages" {
  type = any
}