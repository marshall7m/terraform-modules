resource "aws_iam_role_policy_attachment" "custom_deployment_full_access" {
  count = var.create_deployment_full_access_role ? length(var.deployment_full_access_role_policy_arns) : 0
  
  role       = aws_iam_role.deployment_full_access[0].name
  policy_arn = element(var.deployment_read_access_role_policy_arns, count.index)
}

data "aws_iam_policy_document" "deployment_full_access" {
  count = var.attach_default_deployment_full_access_policy ? 1 : 0

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = var.default_full_access_actions
    
    dynamic "condition" {
      for_each = var.deployment_access_tags
      content {
        test = "StringEquals"
        variable = "aws:ResourceTag/${condition.key}"
        values = ["&{aws:PrincipalTag/${condition.value}}"]
      }
    }
  }
}

data "aws_iam_policy_document" "deployment_full_access_with_mfa" {
  count = var.attach_default_deployment_full_access_policy ? 1 : 0
  
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = var.default_full_access_actions
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.deployment_full_access_role_mfa_age]
    }
    dynamic "condition" {
      for_each = var.deployment_access_tags
      content {
        test = "StringEquals"
        variable = "aws:ResourceTag/${condition.key}"
        values = ["$${aws:PrincipalTag/${condition.value}}"]
      }
    }
  }
}