data "aws_iam_policy_document" "assume_role_with_mfa" {
  count = var.role_requires_mfa ? 1 : 0
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_users
    }
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.role_mfa_age]
    }

    dynamic "condition" {
      for_each = var.role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }

  }
}

data "aws_iam_policy_document" "assume_role" {
  count = var.role_requires_mfa != true ? 1 : 0
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = length(var.trusted_users) > 0 ? [1] : []
      content {
        type        = "AWS"
        identifiers = var.trusted_users
      }
    }

    dynamic "principals" {
        for_each = length(var.trusted_services) > 0 ? [1] : []
      content {
        type        = "Service"
        identifiers = var.trusted_services
      }
    }

    dynamic "condition" {
      for_each = var.role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}