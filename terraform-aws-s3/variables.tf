variable "enabled" {
  description = "Determines if module should create resources or destroy pre-existing resources managed by this module"
  type = bool
  default = true
}

variable "name" {
  description = "Name of the S3 bucket"
  type = string
  default = null
}

variable "force_destroy" {
  description = "Determines if the bucket content will be deleted if the bucket is deleted (True = error-free bucket deletion)"
  type = bool
  default = false
}

variable "tags" {
  description = "Tags to attach to S3 bucket"
  type = map(string)
  default = {}
}

variable "acl" {
    description = "Access Control List for the bucket"
    type = string
    default = "private"
}

variable "trusted_cross_account_ids" {
  description = "Trusted cross-account AWS IDs that have read/write access to the bucket"
  type = list(string)
  default = []
}