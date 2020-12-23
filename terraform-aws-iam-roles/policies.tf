data "aws_iam_policy_document" "this" {
  count = var.allowed_resources != null && var.allowed_actions != null || var.statements != [] ? 1 : 0
  dynamic "statement" {
    for_each = var.allowed_resources != null && var.allowed_actions != null ? [1] : []
    content {
      effect    = "Allow"
      resources = var.allowed_resources
      actions   = var.allowed_actions
    }
  }
  dynamic "statement" {
    for_each = var.statements
    content {
      effect    = statement.value.effect
      resources = statement.value.resources
      actions   = statement.value.actions
      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "this" {
  count       = var.allowed_resources != null && var.allowed_actions != null || var.statements != [] ? 1 : 0
  name        = coalesce(var.policy_name, var.role_name)
  description = var.policy_description
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.this[0].json
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.allowed_resources != null && var.allowed_actions != null || var.statements != [] ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = length(var.custom_role_policy_arns) > 0 ? length(var.custom_role_policy_arns) : 0

  role       = aws_iam_role.this[0].name
  policy_arn = element(var.custom_role_policy_arns, count.index)
}