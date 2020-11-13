output "ecr_repo_url" {
  value = "${aws_ecr_repository.this.repository_url}"
}

output "deployment_group_name" {
  value = "${aws_codedeploy_deployment_group.this.deployment_group_name}"
}
