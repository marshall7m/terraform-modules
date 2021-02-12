variable "groups" {
    #TODO: change variable type when: https://github.com/hashicorp/terraform/issues/19898 is fixed to allow optional object attributes
    description = "List of IAM group configurations (see: https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/modules/iam-group-with-policies/variables.tf)"
    type = any
    default = []
}