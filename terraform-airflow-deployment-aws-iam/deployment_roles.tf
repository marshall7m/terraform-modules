resource "aws_iam_role" "deployment_read_access" {
  count = var.create_deployment_read_access_role ? 1 : 0

  name                 = var.deployment_read_access_role_name
  path                 = var.deployment_read_access_role_path
  max_session_duration = var.deployment_read_access_role_max_session_duration
  description          = var.deployment_read_access_role_description

  force_detach_policies = var.deployment_read_access_role_force_detach_policies
  permissions_boundary  = var.deployment_read_access_role_permissions_boundary

  assume_role_policy = var.deployment_read_access_role_requires_mfa ? data.aws_iam_policy_document.deployment_read_access_with_mfa.json : data.aws_iam_policy_document.deployment_read_access.json

  tags = var.deployment_key_pair_tags
}