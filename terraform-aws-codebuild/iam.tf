locals {
    account_id = coalesce(var.account_id, data.aws_caller_identity.current.id)
    region = coalesce(var.region, data.aws_region.current.name)
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "trust" {
    count = var.role_arn == null ? 1 : 0
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
    count = var.role_arn == null ? 1 : 0

    statement {
        effect = "Allow"
        resources = [
            "arn:aws:codebuild:${local.region}:${local.account_id}:report-group/${aws_codebuild_project.this.name}-*"  
        ]
        actions = [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
        ]
    }

    statement {
        effect = "Allow"
        resources = [
            "arn:aws:codebuild:${local.region}:${local.account_id}:project/${aws_codebuild_project.this.name}"  
        ]
        actions = [
            "codebuild:StartBuild",
            "codebuild:batchGetBuilds"
        ]
    }

    dynamic "statement" {
        for_each = var.cw_logs ? [1] : []
        content {
            sid = "LogsToCW"
            effect = "Allow"
            resources = [
                "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.this.name}",
                "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${aws_codebuild_project.this.name}:*"
            ]
            actions = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    }

    dynamic "statement" {
        for_each = var.s3_logs ? [1] : []
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
    
    dynamic "statement" {
        for_each = var.assumable_role_arns != [] ? [1] : []
        content {
            effect = "Allow"
            actions = ["sts:AssumeRole"]
            resources = var.assumable_role_arns
        }
    }

    dynamic "statement" {
        for_each = var.codepipeline_artifact_bucket_name != null ? [1] : []
        content {
            sid = "CodePipelineArtifactBucketAccess"
            effect = "Allow"
            resources = [
                "arn:aws:s3:::${var.codepipeline_artifact_bucket_name}/*"
            ]
            actions = [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListObjects",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketAcl"
            ]
        }
    }
}

resource "aws_iam_policy" "permission" {
    count = var.role_arn == null ? 1 : 0
    name = var.name
    description = var.role_description
    path = var.role_path
    policy = data.aws_iam_policy_document.permission[0].json
}

resource "aws_iam_role_policy_attachment" "permission" {
  count = var.role_arn == null ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.permission[0].arn
}

resource "aws_iam_role" "this" {
    count = var.role_arn == null ? 1 : 0
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