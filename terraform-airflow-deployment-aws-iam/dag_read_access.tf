locals {
    dags_access_tags = var.dag_access_tags != {} ?  {
        for tag_set in setproduct([
            for key,value in var.dag_access_tags: [
                for tag in setproduct(list(key), try(tolist(value), list(value))): 
                    map(tag[0], tag[1])
                ]
            ]...):
                merge(tag_set...)[var.dag_tag_key] => merge(tag_set...)
    } : null
}

resource "aws_iam_role_policy_attachment" "custom_dag_read_access" {
  for_each = var.create_dag_read_access_roles  && var.dag_read_access_roles_policy_arns != [] ? map(flatten(setproduct(aws_iam_role.dag_read_access[*], var.dag_read_access_roles_policy_arns))) : {}
  
  role       = each.key
  policy_arn = each.value
}

data "aws_iam_policy_document" "dag_read_access" {
  for_each = local.dags_access_tags
  policy_id = each.key

  statement {
    effect = "Allow"
    resources = ["*"]
    actions = local.default_read_access_actions
    
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

data "aws_iam_policy_document" "dag_read_access_with_mfa" {
  for_each = local.dags_access_tags
  policy_id = each.key
  
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = var.dag_read_access_roles_actions != [] ? var.dag_read_access_roles_actions : local.default_read_access_actions
    
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "aws:MultiFactorAuthAge"
      values   = [var.dag_read_access_roles_mfa_age]
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