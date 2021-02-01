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
