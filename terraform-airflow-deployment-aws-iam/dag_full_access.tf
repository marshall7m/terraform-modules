resource "aws_iam_role_policy_attachment" "custom_dag_full_access" {
  for_each = var.create_dag_full_access_roles  && var.dag_full_access_roles_policy_arns != [] ? map(flatten(setproduct(aws_iam_role.dag_full_access[*], var.dag_full_access_roles_policy_arns))) : {}
  
  role       = each.key
  policy_arn = each.value
}

data "aws_iam_policy_document" "dag_full_access" {
  for_each = local.dags_access_tags
  policy_id = each.key

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = var.default_full_access_actions
    
    dynamic "condition" {
      for_each = each.value
      content {
        test = "StringEquals"
        variable = "aws:ResourceTag/${condition.key}"
        values = ["&{aws:PrincipalTag/${condition.value}}"]
      }
    }
  }
}

data "aws_iam_policy_document" "dag_full_access_with_mfa" {
  for_each = var.attach_default_deployment_full_access_policy ? local.dags_access_tags : {}
  policy_id = each.key
  
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
      values   = [var.dag_full_access_roles_mfa_age]
    }
    dynamic "condition" {
      for_each = each.value
      content {
        test = "StringEquals"
        variable = "aws:ResourceTag/${condition.key}"
        values = ["$${aws:PrincipalTag/${condition.value}}"]
      }
    }
  }
}

