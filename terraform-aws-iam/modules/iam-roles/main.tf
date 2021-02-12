resource "aws_iam_role" "this" {
  count                = var.create_role ? 1 : 0
  name                 = var.role_name
  path                 = var.role_path
  max_session_duration = var.role_max_session_duration
  description          = var.role_description

  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary

  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json

  tags = merge(var.role_tags, var.common_tags)
}