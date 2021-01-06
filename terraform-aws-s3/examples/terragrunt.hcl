include {
    path = find_in_parent_folders()
}

locals {
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    account_id = local.account_vars.locals.account_id
}

terraform {
    source = "../"
}

inputs = {
    enabled = true
    name = "${uuid()}"
    tags = {
        foo = "bar"
    }
    trusted_cross_account_ids = [local.account_id]
}