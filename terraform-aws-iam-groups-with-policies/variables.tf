variable "groups" {
    description = "List of IAM group configurations (see: https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/modules/iam-group-with-policies/variables.tf)"
    type = any
    default = []
}