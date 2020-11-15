module "iam_roles" {
    for_each = var.roles
    source = "github.com/terraform-aws-modules/terraform-aws-iam/modules/iam-assumable-role"

    create_role = each.value.create_role
    role_name = each.value.role_name

    role_requires_mfa = each.value.role_requires_mfa
    mfa_age = each.value.mfa_age

    max_session_duration = each.value.max_session_duration

    create_instance_profile = each.value.create_instance_profile

    role_path = each.value.role_path
    role_permissions_boundary_arn = each.value.role_permissions_boundary_arn
    force_detach_policies = each.value.force_detach_policies
    role_description = each.value.role_description
    tags = each.value.tags

    custom_role_policy_arns = each.value.custom_role_policy_arns
    number_of_custom_role_policy_arns = each.value.number_of_custom_role_policy_arns

    admin_role_policy_arn = each.value.admin_role_policy_arn
    attach_admin_policy = each.value.attach_admin_policy

    poweruser_role_policy_arn = each.value.poweruser_role_policy_arn
    attach_poweruser_policy = each.value.attach_poweruser_policy

    readonly_role_policy_arn = each.value.readonly_role_policy_arn
    attach_readonly_policy = each.value.attach_readonly_policy
    
    role_sts_externalid = each.value.role_sts_externalid

    trusted_role_arns = each.value.trusted_role_arns
    trusted_role_services = each.value.trusted_role_services
    trusted_role_actions = each.value.trusted_role_actions
}