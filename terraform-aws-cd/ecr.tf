resource "aws_ecr_repository" "this" {
  name                 = "${var.ecr_base_domain}/${aws_codedeploy_deployment_group.this.deployment_group_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.ecr_tags,
    var.global_tags
  )
}


resource "aws_ssm_parameter" "ecr_repo_url" {
  count = var.ecr_repo_url_to_ssm ? 1 : 0
  name  = var.ssm_ecr_repo_url_name != "" ?  var.ssm_ecr_repo_url_name : "${aws_codedeploy_deployment_group.this.deployment_group_name}-ecr-repo-url"
  type  = "SecureString"
  value = aws_ecr_repository.this.repository_url
  tags = merge(
    var.ssm_ecr_repo_url_tags,
    var.global_tags
  )
}