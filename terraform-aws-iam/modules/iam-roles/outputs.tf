output "role_arn" {
  value = try(aws_iam_role.this[0].arn, null)
}

output "policy_arn" {
  value = try(aws_iam_policy.permissions[0].arn, null)
}