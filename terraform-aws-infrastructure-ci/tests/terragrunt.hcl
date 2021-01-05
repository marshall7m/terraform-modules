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
    account_id = local.account_id
    pipeline_name = "test-pipeline"

    codestar_conn = {
        provider = "GitHub"
        name = "test-conn"
    }
    repo_id = "marshall7m/terraform-modules"
    branch = "master"

    build_name = "test-build"
    buildspec_path = "${get_terragrunt_dir()}/buildspec.yaml"
    build_env_vars = [
        {
            
        }
    ]
    plan_role_name = "cross-account-tf-plan-access"
    apply_role_name = "cross-account-tf-apply-access"
    vailidate_command = "terragrunt validate-all"
    plan_command = "terragrunt plan-all"
    apply_command = "terragrunt apply-all"

    stages = [
        {
            name = "shared-services"
            id = local.account_id
            paths = []
            terragrunt_version = "0.25.4"
            terraform_version = "0.14.3"
            order = 1
        },
        {
            name = "dev"
            id = local.account_id
            paths = []
            terragrunt_version = "0.25.4"
            terraform_version = "0.14.3"
            order = 2
        }
    ]

}