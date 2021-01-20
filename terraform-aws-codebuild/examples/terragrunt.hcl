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
    region = "us-west-2"
    name = "foo-build"
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
      type = "GITHUB"
      location        = "https://github.com/marshall7m/terrace.git"
      buildspec = "buildspec.yml"
    }
    cache = {
      type  = "LOCAL"
      modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
    }
}