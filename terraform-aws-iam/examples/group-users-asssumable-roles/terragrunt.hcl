include {
  path = find_in_parent_folders()
}

terraform {
    source = "../"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id = local.account_vars.locals.account_id
}

inputs = {
    groups = [
        {
            name = "dev-account-admin-access"
            assumable_roles = [
                "arn:aws:iam::${local.account_id}:role/cross-account-admin-access"
            ]
            group_users = [
                "Joe"
            ]
        },
        {
            name = "dev-account-read-access"
            assumable_roles = [
                "arn:aws:iam::${local.account_id}:role/cross-account-read-access"
            ]
            group_users = [
                "John"
            ]
        }
    ]
}