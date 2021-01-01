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
    account_id = account_id
    trusted_admin_arns = ["arn:aws:iam::${local.account_id}:user/test-admin-user"]
    trusted_usage_arns = ["arn:aws:iam::${local.account_id}:user/test-dev-user"]
}