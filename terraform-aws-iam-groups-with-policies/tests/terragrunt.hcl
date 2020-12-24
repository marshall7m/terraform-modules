include {
    path = find_in_parent_folders()
}

terraform {
    source = "../"
}

inputs = {
    groups = [
        {
            name = "full-access"
            custom_group_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
            group_users = ["bar"]
        },
        {
            name = "billing"
            custom_group_policy_arns = ["arn:aws:iam::aws:policy/job-function/Billing"]
            group_users = ["foo"]
        }
    ]
}