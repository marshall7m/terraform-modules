resource "aws_kms_key" "this" {
    count = var.kms_key_arn == null ? 1 : 0
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    policy = data.aws_iam_policy_document.kms[0].json
    tags = merge(
        var.kms_key_tags,
        var.common_tags
    )
}

resource "aws_kms_alias" "this" {
  count = var.kms_key_arn == null && var.kms_alias == null ? 1 : 0
  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.this[0].key_id
}

data "aws_iam_policy_document" "kms" {
    count = var.kms_key_arn == null && var.kms_key_admin_arns != [] ? 1 : 0
    statement {
        sid = "EnableUserPermissions"
        effect = "Allow"
        actions = ["kms:*"]
        principals {
            type        = "AWS"
            identifiers = ["arn:aws:iam::${var.account_id}:root"]
        }
        resources = ["*"]
    }

    statement {
        sid = "AdminPermissions"
        effect = "Allow"
        actions = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
        ]
        principals {
            type        = "AWS"
            identifiers = var.kms_key_admin_arns
        }
        resources = ["*"]
    }

    statement {
        sid = "UsagePermissions"
        effect = "Allow"
        actions = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
        ]
        principals {
            type        = "AWS"
            identifiers = concat([aws_iam_role.this[0].arn], local.action_role_arns)
        }
        resources = ["*"]
    }

    statement {
        sid = "GrantPermissions"
        effect = "Allow"
        actions = [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
        ]
        principals {
            type        = "AWS"
            identifiers = concat([aws_iam_role.this[0].arn], local.action_role_arns)
        }
        resources = ["*"]

        condition {
            test = "Bool"
            variable = "kms:GrantIsForAWSResource"
            values = ["true"]
        }
    }
}