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
    role_name = "foo-role"
    trusted_services = ["glue.amazonaws.com"]
    allowed_resources = ["*"]
    allowed_actions = ["s3:ListBuckets"]
    statements = [
        {
            effect = "Allow"
            resources = ["arn:aws:s3:::foo-terragrunt-tests/*"]
            actions = ["s3:GetObject"]
        }
    ]
    custom_role_policy_arns = ["arn:aws:iam::${local.account_id}:policy/service-role/AWSGlueServiceRole-test-crawler"]
}
