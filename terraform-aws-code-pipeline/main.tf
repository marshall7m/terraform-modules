# Feature: Create stage & action preset/template blocks?

locals {
    # Codepipeline action role ARNs
    action_role_arns = distinct(compact([for action in flatten(var.stages[*].actions): try(action.role_arn, "")]))
    # Cross-account AWS account_ids
    trusted_cross_account_ids = distinct([for id in data.aws_arn.action_roles[*].account: id if id != var.account_id])
    # Cross-account AWS account ARNs used for S3 artifact bucket policy
    trusted_cross_account_arns = formatlist("arn:aws:iam::%s:root", local.trusted_cross_account_ids)
    # Cross-account AWS role resources used for CodePipeline IAM permissions
    trusted_cross_account_roles = formatlist("arn:aws:iam::%s:role/*", local.trusted_cross_account_ids)
    # Distinct CodePipeline action providers used for CodePipeline IAM permissions
    action_providers = distinct(flatten(var.stages[*].actions[*].provider))
}

data "aws_arn" "action_roles" {
    count = length(local.action_role_arns)
    arn = local.action_role_arns[count.index]
}

resource "aws_codepipeline" "this" {
  name     = var.pipeline_name
  role_arn = coalesce(var.role_arn, aws_iam_role.this[0].arn)

  artifact_store {
    location = var.artifact_bucket_name
    type     = "S3"

    dynamic "encryption_key" {
      for_each = var.kms_key_arn != null || var.encrypt_artifacts == true ? [1] : []
      content {
        id   = coalesce(var.kms_key_arn, try(aws_kms_key.this[0].arn), null)
        type = "KMS"
      }
    }
  }
  
  dynamic "stage" {
      for_each = {for stage in var.stages: stage.name => stage}
      content {
          name = stage.key
          
          dynamic "action" {
              for_each = {for action in stage.value.actions: action.name => action}
              content {
                name             = action.value.name
                category         = action.value.category
                owner            = action.value.owner
                provider         = action.value.provider
                version          = action.value.version
                input_artifacts = try(action.value.input_artifacts, [])
                output_artifacts = try(action.value.output_artifacts, [])
                run_order = try(action.value.run_order, null)
                role_arn = try(action.value.role_arn, null)
                region = try(action.value.region, null)
                namespace = try(action.value.namespace, null)
                configuration = try(action.value.configuration, null)
              }
          }
      }
  }
  tags = merge(var.pipeline_tags, var.common_tags)
}

#### IAM ####

data "aws_iam_policy_document" "permissions" {
    count = var.role_arn == null ? 1 : 0

    statement {
        sid = "S3ArtifactBucketAccess"
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:Put*"
        ]
        resources = ["arn:aws:s3:::${var.artifact_bucket_name}/*"]
    }

    statement {
        effect = "Allow"
        actions = ["iam:PassRole"]
        resources = ["*"]
        condition {
            test = "StringEqualsIfExists"
            variable = "iam:PassedToService"
            values = [
                "cloudformation.amazonaws.com",
                "elasticbeanstalk.amazonaws.com",
                "ec2.amazonaws.com",
                "ecs-tasks.amazonaws.com"
            ]
        }
    }
    
    dynamic "statement" {
        for_each = length(local.trusted_cross_account_roles) > 0 ? [1] : []
        content {
            effect = "Allow"
            actions = ["sts:AssumeRole"]
            resources = local.trusted_cross_account_roles
        }
    }

    dynamic "statement" {
        for_each = contains(local.action_providers, "CodeStarSourceConnection") ? [1] : []
        content {
            effect = "Allow"
            actions = ["codestar-connections:UseConnection"]
            resources = compact([for action in flatten(var.stages[*].actions): try(action.configuration["ConnectionArn"], "")])
        }
    }

    dynamic "statement" {
        for_each = contains(local.action_providers, "CodeBuild") ? [1] : []
        content {
            effect = "Allow"
            actions = [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ]
            resources = ["*"]
            #TODO: Create finer resource permissions
            # resources = formatlist("arn:aws:codebuild:${var.region}:${var.account_id}:project/%s", distinct(flatten([for action in var.stages[*].actions[*]: try(action.configuration["ProjectName"]])))
        }
    }

    dynamic "statement" {
        for_each = contains(local.action_providers, "Manual") ? [1] : []
        content {
            effect = "Allow"
            actions = ["sns:Publish"]
            resources = ["*"]
        }
    }

    dynamic "statement" {
        for_each = contains(local.action_providers, "CodeDeploy") ? [1] : []
        content {
            effect = "Allow"
            actions = [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ]
            resources = ["*"]
        }
    }
}

resource "aws_iam_policy" "permissions" {
    count = var.role_arn == null ? 1 : 0
    name = var.pipeline_name
    description = "Allows codepipeline to assume defined service roles within the pipeline's actions and trigger AWS services defined within the pipeline's actions"
    path = var.role_path
    policy = data.aws_iam_policy_document.permissions[0].json
}

resource "aws_iam_role_policy_attachment" "permissions" {
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.permissions[0].arn
}

data "aws_iam_policy_document" "trust" {
    count = var.role_arn == null ? 1 : 0
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["codepipeline.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "this" {
    count = var.role_arn == null ? 1 : 0
    name = var.pipeline_name
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