output "users_config" {
  value = { for user in module.aws_users : user.this_iam_user_name => user }
}

output "user_count" {
  value = length(module.aws_users)
}