output "ecr_repo_url" {
  value = try(aws_ecr_repository.this[0].repository_url, null)
}

output "cd_app_name" {
  value = var.cd_app_name
}

output "cd_config_name" {
  value = var.cd_config_name
}

output "cd_group_name" {
  value = var.cd_group_name
}
