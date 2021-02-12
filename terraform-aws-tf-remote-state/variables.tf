variable "bucket" {
  description = "AWS S3 Bucket name"
  type        = string
  default     = "terraform-remote-state"
}

variable "bucket_tags" {
  description = "Tags to attach to S3 bucket"
  type        = map(string)
  default     = {}
}

variable "db_table" {
  description = "AWS DynamoDB table name"
  type        = string
  default     = "terraform-locks"
}

variable "db_table_tags" {
  description = "Tags to attach to DyanmoDB table"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Tags to attach to both S3 bucket and DynamoDB table"
  type        = map(string)
  default     = {}
}