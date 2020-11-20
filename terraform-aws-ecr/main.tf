resource "aws_ecr_repository" "this" {
  count                = var.create_repo ? 1 : 0
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}


resource "aws_ssm_parameter" "ecr_repo_url" {
  count = var.create_repo && var.ecr_repo_url_to_ssm ? 1 : 0
  name  = coalesce(var.ssm_key, var.name)
  type  = "SecureString"
  value = aws_ecr_repository.this[0].repository_url
  tags = coalesce(var.ssm_tags, var.tags)
}