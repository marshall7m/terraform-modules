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

data "aws_iam_policy_document" "permission" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        resources = var.cross_account_assumable_roles
    }

    statement {
        sid = "LogsToCW"
        effect = "Allow"
        resources = [
            "arn:aws:logs:us-west-2:501460770806:log-group:/aws/codebuild/${aws_codebuild_project.this.id}",
            "arn:aws:logs:us-west-2:501460770806:log-group:/aws/codebuild/${aws_codebuild_project.this.id}:*"
        ]
        actions = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
    }

    statement {
        effect = "Allow"
        resources = [
            "arn:aws:codebuild:us-west-2:501460770806:report-group/${aws_codebuild_project.this.id}-*"  
        ]
        actions = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
        ]
    }

    dynamic "statement" {
        for_each = var.s3_log_key != null && var.s3_log_bucket != null ? [1] : []
        content {
            sid = "LogsToS3"
            effect = "Allow"
            resources = [
                "arn:aws:s3:::${var.s3_log_bucket}",
                "arn:aws:s3:::${var.s3_log_key}/*"
            ]
            actions = [
                "s3:PutObject",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        }
    }
}

resource "aws_iam_policy" "permission" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    name = var.name
    description = var.role_description
    path = var.role_path
    policy = data.aws_iam_policy_document.cross_account_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "permission" {
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.cross_account_assume_role[0].arn
}

resource "aws_iam_role" "this" {
    count = var.cross_account_assumable_roles != null ? 1 : 0
    name = var.name
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