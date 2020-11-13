resource "aws_iam_role" "code_deploy" {
  count = var.create_role ? 1 : 0
  name = var.role_name
  path                 = var.role_path
  max_session_duration = var.max_session_duration
  description          = var.role_description

  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary_arn

  assume_role_policy = var.custom_code_deploy_trust_policy != null ? var.custom_code_deploy_trust_policy : aws_iam_policy_document.default_trust_policy.json

  tags = var.tags
}
