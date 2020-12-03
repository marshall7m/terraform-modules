resource "aws_iam_role" "admin" {
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

resource "aws_iam_role" "dev" {
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

resource "aws_iam_role" "read" {
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

resource "aws_iam_role" "tf_plan" {
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

resource "aws_iam_role" "tf_apply" {
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

resource "aws_iam_role" "limited_s3_read" {
  count                = length(var.limited_s3_read_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.limited_s3_read_role_name
  path                 = var.limited_s3_read_role_path
  max_session_duration = var.limited_s3_read_role_max_session_duration
  description          = var.limited_s3_read_role_description

  force_detach_policies = var.limited_s3_read_role_force_detach_policies
  permissions_boundary  = var.limited_s3_read_role_permissions_boundary

  assume_role_policy = data.aws_iam_policy_document.assume_limited_s3_read_role[0].json

  tags = var.limited_s3_read_role_tags
}

resource "aws_iam_role" "cd" {
  count                = length(var.cd_role_cross_account_arns) > 0 ? 1 : 0
  name                 = var.cd_role_name
  path                 = var.cd_role_path
  max_session_duration = var.cd_role_max_session_duration
  description          = var.cd_role_description

  force_detach_policies = var.cd_role_force_detach_policies
  permissions_boundary  = var.cd_role_permissions_boundary

  assume_role_policy = data.aws_iam_policy_document.assume_cd_role[0].json

  tags = var.cd_role_tags
}