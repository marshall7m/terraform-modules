variable "users" {
  description = "List of AWS user configurations (see source module: https://github.com/terraform-aws-modules/terraform-aws-iam/blob/v3.6.0/modules/iam-user/variables.tf)"
  type        = list(any)
}

variable "common_tags" {
  description = "Tags for all users created"
  type = map(string)
  default = {}
}