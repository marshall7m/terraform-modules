module "aws_groups" {
  for_each = {for group in var.groups: group.name => group}
  source = "github.com/terraform-aws-modules/terraform-aws-iam/modules/iam-group-with-assumable-roles-policy"

  name = each.value.name
  assumable_roles = each.value.assumable_roles
  group_users = each.value.group_users
}