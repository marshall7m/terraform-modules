resource "aws_iam_role" "dag_read_access_roles" {
  for_each = var.create_dag_read_access_roles ? local.dags_access_tags : {}

  name                 = "${each.key}-read-access-role"
  path                 = var.dag_read_access_roles_path
  max_session_duration = var.dag_read_access_roles_max_session_duration
  description          = var.dag_read_access_roles_description

  force_detach_policies = var.dag_read_access_roles_force_detach_policies
  permissions_boundary  = var.dag_read_access_roles_permissions_boundary

  assume_role_policy = var.dag_read_access_roles_requires_mfa ? data.aws_iam_policy_document.dag_read_access_with_mfa[each.key].json : data.aws_iam_policy_document.dag_read_access[each.key].json

  tags = merge(var.dag_read_access_roles_tags, local.dags_access_tags[each.key])
}