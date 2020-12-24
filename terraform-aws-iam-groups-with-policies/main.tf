module "iam_groups" {
    for_each = {for group in var.groups: group.name => group}
    source = "github.com/terraform-aws-modules/terraform-aws-iam/modules/iam-group-with-policies"

    create_group = try(each.value.create_group, true)
    name = try(each.value.name, "")
    aws_account_id = try(each.value.aws_account_id, "")
    attach_iam_self_management_policy = try(each.value.attach_iam_self_management_policy, true)
    custom_group_policies = try(each.value.custom_group_policies, [])
    custom_group_policy_arns = try(each.value.custom_group_policy_arns, [])
    group_users = try(each.value.group_users, [])
    iam_self_management_policy_name_prefix = try(each.value.iam_self_management_policy_name_prefix, "IAMSelfManagement-")
}