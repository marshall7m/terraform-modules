resource "aws_iam_role" "admin_role" {
  count                = length(var.admin_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.admin_role_name
  path                 = var.admin_role_path
  max_session_duration = var.admin_role_max_session_duration
  description          = var.admin_role_description

  force_detach_policies = var.admin_role_force_detach_policies
  permissions_boundary  = var.admin_role_permissions_boundary

  assume_role_policy = var.admin_role_requires_mfa ? data.aws_iam_policy_document.assume_admin_role_with_mfa[0].json : data.aws_iam_policy_document.assume_admin_role[0].json

  tags = var.admin_role_tags
}

resource "aws_iam_role" "dev_role" {
  count                = length(var.dev_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.dev_role_name
  path                 = var.dev_role_path
  max_session_duration = var.dev_role_max_session_duration
  description          = var.dev_role_description

  force_detach_policies = var.dev_role_force_detach_policies
  permissions_boundary  = var.dev_role_permissions_boundary

  assume_role_policy = var.dev_role_requires_mfa ? data.aws_iam_policy_document.assume_dev_role_with_mfa[0].json : data.aws_iam_policy_document.assume_dev_role[0].json

  tags = var.dev_role_tags
}

resource "aws_iam_role" "read_role" {
  count                = length(var.read_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.read_role_name
  path                 = var.read_role_path
  max_session_duration = var.read_role_max_session_duration
  description          = var.read_role_description

  force_detach_policies = var.read_role_force_detach_policies
  permissions_boundary  = var.read_role_permissions_boundary

  assume_role_policy = var.read_role_requires_mfa ? data.aws_iam_policy_document.assume_read_role_with_mfa[0].json : data.aws_iam_policy_document.assume_read_role[0].json

  tags = var.read_role_tags
}

resource "aws_iam_role" "tf_plan_role" {
  count                = length(var.tf_plan_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.tf_plan_role_name
  path                 = var.tf_plan_role_path
  max_session_duration = var.tf_plan_role_max_session_duration
  description          = var.tf_plan_role_description

  force_detach_policies = var.tf_plan_role_force_detach_policies
  permissions_boundary  = var.tf_plan_role_permissions_boundary

  assume_role_policy = data.aws_iam_policy_document.assume_tf_plan_role[0].json

  tags = var.tf_plan_role_tags
}

resource "aws_iam_role" "tf_apply_role" {
  count                = length(var.tf_apply_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.tf_apply_role_name
  path                 = var.tf_apply_role_path
  max_session_duration = var.tf_apply_role_max_session_duration
  description          = var.tf_apply_role_description

  force_detach_policies = var.tf_apply_role_force_detach_policies
  permissions_boundary  = var.tf_apply_role_permissions_boundary

  assume_role_policy = data.aws_iam_policy_document.assume_tf_apply_role[0].json

  tags = var.tf_apply_role_tags
}

