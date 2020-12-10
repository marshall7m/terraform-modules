include {
  path = find_in_parent_folders()
}

terraform {
    source = "../"
}

locals {
  account_id = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}


inputs = {
    name = "tf-infrastructure"
    resource_prefix = "demo-org"
    resource_suffix = "us-west-2"
    terraform_version = "0.13.5"
    terragrunt_version = "0.25.4"
    source_type = "CODEPIPELINE"
    cross_account_assumable_roles = ["arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access"]
    artifacts = {
        type = "CODEPIPELINE"
    }
    buildspec = "test/buildspec.yml"
    common_tags = {"foo" = "bar"}
}