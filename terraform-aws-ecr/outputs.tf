output "ecr_repo_url" {
  value = try(aws_ecr_repository.this[0].repository_url, null)
}