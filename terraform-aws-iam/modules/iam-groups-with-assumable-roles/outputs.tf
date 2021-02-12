output "group_users" {
  description = "List of IAM users in IAM groups"
  value       = {for name,_ in module.aws_groups: name => module.aws_groups[name].this_group_users}
}

output "assumable_roles" {
  description = "List of ARNs of IAM roles which members of IAM groups can assume"
  value       = {for name,_ in module.aws_groups: name => module.aws_groups[name].this_assumable_roles}
}

output "policy_arn" {
  description = "Assume role policy ARN of IAM groups"
  value       = {for name,_ in module.aws_groups: name => module.aws_groups[name].this_policy_arn}
}

output "group_name" {
  description = "IAM group names"
  value       = [for name,_ in module.aws_groups: name]
}