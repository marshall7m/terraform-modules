output "aws_account_id" {
    value = try(module.iam_groups.outputs.aws_account_id, null)
}

output "this_group_name" {
    value = try(module.iam_groups.outputs.this_group_name, null)
}

output "this_group_users" {
    value = try(module.iam_groups.outputs.this_group_users, null)
}