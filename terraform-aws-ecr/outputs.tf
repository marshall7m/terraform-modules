output "ecr_repo_url" {
  value = try(aws_ecr_repository.this[0].repository_url, null)
}

output "ssm_arn" {
  value = try(aws_ssm_parameter.this[0].arn, null)
}

output "ssm_version" {
  value = try(aws_ssm_parameter.this[0].version, null)
}