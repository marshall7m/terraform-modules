data "aws_iam_policy" "default_read_access" {
  count = var.attach_default_deployment_read_access_policy || var.attach_default_dag_read_access_policy ? 1 : 0
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "default_read_access" {
  count = var.attach_default_deployment_read_access_policy || var.attach_default_dag_read_access_policy ? 1 : 0
  source_json = data.aws_iam_policy.default_read_access[0].policy
}

resource "aws_iam_role_policy_attachment" "custom_deployment_read_access" {
  count = var.create_deployment_read_access_role ? length(var.deployment_read_access_role_policy_arns) : 0
  
  role       = aws_iam_role.deployment_read_access[0].name
  policy_arn = element(var.deployment_read_access_role_policy_arns, count.index)
}

locals {
  default_read_access_actions = var.attach_default_deployment_read_access_policy || var.attach_default_dag_read_access_policy ? flatten([for statement in jsondecode(data.aws_iam_policy_document.default_read_access[0].json)["Statement"][*]: statement["Action"]]) : null
}

data "aws_iam_policy_document" "deployment_read_access" {
  count = var.attach_default_deployment_read_access_policy ? 1 : 0
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = local.default_read_access_actions
    
    dynamic "condition" {
      for_each = var.deployment_key_pair_tags
      content {
        test = "StringEquals"
        variable = "aws:ResourceTag/${condition.key}"
        values = ["$${aws:PrincipalTag/${condition.value}}"]
      }
    }
  }
}

data "aws_iam_policy_document" "deployment_read_access_with_mfa" {
  count = var.attach_default_deployment_read_access_policy ? 1 : 0
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = local.default_read_access_actions
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.deployment_read_access_role_mfa_age]
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
