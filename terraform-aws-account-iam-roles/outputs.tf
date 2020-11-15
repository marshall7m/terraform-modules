output "roles_config" {
    value = {for role in module.iam_roles[*]: role.outputs.this_iam_role_name => role.outputs[*]}
}

