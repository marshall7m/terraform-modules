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
    region = "us-east-1"
    name = "tf-infrastructure"
    cross_account_assumable_roles = ["arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access"]
    artifacts = {
        type = "CODEPIPELINE"
    }
    codepipeline_artifact_bucket_name = "test"
    common_tags = {"foo" = "bar"}
    build_source = {
      type = "CODEPIPELINE"
      buildspec = "arn:aws:s3:::private-demo-org/buildspec.yml"
    }
}