resource "aws_ecr_repository" "this" {
  count                = var.create_repo ? 1 : 0
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.ecr_tags, var.common_tags)
}


resource "aws_ssm_parameter" "this" {
  count = var.create_repo && var.ecr_repo_url_to_ssm ? 1 : 0
  name  = coalesce(var.ssm_key, var.name)
  type  = "SecureString"
  value = aws_ecr_repository.this[0].repository_url
  tags  = merge(var.ssm_tags, var.common_tags)
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.codebuild_access ? 1 : 0
  repository = aws_ecr_repository.this[0].name

  policy = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.codebuild_access ? 1 : 0
  statement {
    sid    = "CodeBuildAccess"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}
