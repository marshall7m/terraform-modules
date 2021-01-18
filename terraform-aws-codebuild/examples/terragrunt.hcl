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
        type = "NO_ARTIFACTS"
    }
    common_tags = {"foo" = "bar"}
    environment = {
      type = "LINUX_CONTAINER"
      image = "aws/codebuild/standard:4.0"
      compute_type = "BUILD_GENERAL1_SMALL"
    }
    build_source = {
      type = "CODEPIPELINE"
      buildspec = "arn:aws:s3:::private-demo-org/buildspec.yml"
    }
    cache = {
      type  = "LOCAL"
      modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
    }
}