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
    artifacts = {
        type = "NO_ARTIFACTS"
    }
    common_tags = {"foo" = "bar"}
    environment = {
      type = "LINUX_CONTAINER"
      image = "aws/codebuild/standard:4.0"
      compute_type = "BUILD_GENERAL1_SMALL"
      environment_variables = [
        {
          name = "bar"
          value = "foo"
        }
      ]
    }
    source_auth_ssm_param_name = "github-token"
    build_source = {
      type = "CODEPIPELINE"
      buildspec = "arn:aws:s3:::private-demo-org/buildspec.yml"
      auth = {
        type = "OAUTH"
      }
    }
    cache = {
      type  = "LOCAL"
      modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
    }
}