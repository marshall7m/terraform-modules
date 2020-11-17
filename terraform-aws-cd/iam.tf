locals {
  cd_role_name   = var.cd_role_name == null ? "${var.cd_group_name}-access-role" : var.cd_role_name
  cd_policy_name = var.cd_policy_name == null ? "${var.cd_group_name}-access-role" : var.cd_policy_name
}

resource "aws_iam_role" "cd_role" {
  count                = var.cd_role_arn == null ? 1 : 0
  name                 = local.cd_role_name
  path                 = var.cd_role_path
  max_session_duration = var.cd_role_max_session_duration
  description          = var.cd_role_description

  force_detach_policies = var.cd_role_force_detach_policies
  permissions_boundary  = var.cd_role_permissions_boundary

  assume_role_policy = data.aws_iam_policy_document.assume_cd_role[0].json

  tags = var.cd_role_tags
}

data "aws_iam_policy_document" "cd_permissions" {
  count = var.cd_allowed_resources != null && var.cd_allowed_actions != null || var.cd_role_statements != null ? 1 : 0
  dynamic "statement" {
    for_each = var.cd_allowed_resources != [] && var.cd_allowed_actions != [] ? {} : null
    content {
      effect    = "Allow"
      resources = var.cd_allowed_resources
      actions   = var.cd_allowed_actions
    }
  }
  dynamic "statement" {
    for_each = var.cd_role_statements != [] ? { for statement in var.cd_role_statements : statement.effect => statement } : {}
    content {
      effect    = statement.value.effect
      resources = statement.value.resources
      actions   = statement.value.actions
      dynamic "condition" {
        for_each = can(statement.value.condition) ? { for condition in statement.value.condition : condition.test => condition } : {}
        content {
          test     = statement.value.condition.test
          variable = statement.value.condition.variable
          values   = statement.value.condition.values
        }
      }

    }
  }
}

resource "aws_iam_policy" "cd_permissions" {
  count       = var.cd_allowed_resources != null && var.cd_allowed_actions != null || var.cd_role_statements != null ? 1 : 0
  name        = local.cd_policy_name
  description = var.cd_policy_description
  path        = var.cd_policy_path
  policy      = data.aws_iam_policy_document.cd_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "cd_permissions" {
  count = var.cd_allowed_resources != null && var.cd_allowed_actions != null || var.cd_role_statements != null ? 1 : 0

  role       = aws_iam_role.cd_role[0].name
  policy_arn = aws_iam_policy.cd_permissions[0].arn
}

resource "aws_iam_role_policy_attachment" "custom_cd_permissions" {
  count = var.cd_role_arn == null && length(var.custom_cd_role_policy_arns) > 0 ? length(var.custom_cd_role_policy_arns) : 0

  role       = aws_iam_role.cd_role[0].name
  policy_arn = element(var.custom_cd_role_policy_arns, count.index)
}

data "aws_iam_policy_document" "assume_cd_role" {
  count = var.cd_role_arn == null ? 1 : 0
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    dynamic "condition" {
      for_each = var.cd_role_conditions != [] ? { for condition in var.cd_role_conditions : condition.test => condition } : null
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}