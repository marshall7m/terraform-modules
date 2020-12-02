data "aws_iam_policy_document" "trust" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["codebuild.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "cross_account_assume_role" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        resources = var.cross_account_assumable_roles
    }
}

resource "aws_iam_policy" "cross_account_assume_role" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    name = "${var.resource_prefix}-${var.name}-${var.resource_suffix}"
    description = var.role_description
    path = var.role_path
    policy = data.aws_iam_policy_document.cross_account_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "cross_account_assume_role" {
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.cross_account_assume_role[0].arn
}

resource "aws_iam_role" "this" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    name = "${var.resource_prefix}-${var.name}-${var.resource_suffix}"
    path                 = var.role_path
    max_session_duration = var.role_max_session_duration
    description          = var.role_description

    force_detach_policies = var.role_force_detach_policies
    permissions_boundary  = var.role_permissions_boundary
    assume_role_policy = data.aws_iam_policy_document.trust[0].json
    tags = merge(
        var.role_tags,
        var.common_tags
    )
}