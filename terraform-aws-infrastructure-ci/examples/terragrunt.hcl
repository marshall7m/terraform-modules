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

    cmk_trusted_admin_arns = ["arn:aws:iam::${local.account_id}:role/test-build"]

    build_name = "test-build"
    buildspec = "terraform-aws-infrastructure-ci/tests/buildspec.yaml"
    build_env_vars = [
        {
            name  = "TF_IN_AUTOMATION"
            value = "true"
        },
        {
            name  = "TF_INPUT"
            value = "false"
        }
    ]
    build_assumable_role_arns = [
        "arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access",
        "arn:aws:iam::${local.account_id}:role/cross-account-tf-apply-access"
    ]

    stages = [
        {
            name = "shared-services"
            common_env_vars = [ 
                {
                    name = "PATH"
                    value = "infrastructure-live/shared-services-account/"
                }
            ]
            validate_env_vars = [ 
                {
                    name = "CI_ROLE_ARN"
                    value = "arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access"
                },
                {
                    name = "COMMANDS"
                    value = "terragrunt validate-all"
                }
            ]
            plan_env_vars = [ 
                {
                    name  = "CI_ROLE_ARN"
                    value = "arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access"
                    type  = "PLAINTEXT"
                },
                {
                    name = "COMMANDS"
                    value = "terragrunt plan-all"
                }
            ]
            apply_env_vars = [
                {
                    name = "CI_ROLE_ARN"
                    value = "arn:aws:iam::${local.account_id}:role/cross-account-tf-apply-access"
                },
                {
                    name = "COMMANDS"
                    value = "terragrunt apply-all -auto-approve"
                }
            ]
            order = 1
        },
        {
            name = "dev"
            common_env_vars = [ 
                {
                    name = "PATH"
                    value = "infrastructure-live/dev-account/"
                }
            ]
            validate_env_vars = [ 
                {
                    name = "CI_ROLE_ARN"
                    value = "arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access"
                },
                {
                    name = "COMMANDS"
                    value = "terragrunt validate-all"
                }
            ]
            plan_env_vars = [ 
                {
                    name  = "CI_ROLE_ARN"
                    value = "arn:aws:iam::${local.account_id}:role/cross-account-tf-plan-access"
                    type  = "PLAINTEXT"
                },
                {
                    name = "COMMANDS"
                    value = "terragrunt plan-all"
                }
            ]
            apply_env_vars = [
                {
                    name = "CI_ROLE_ARN"
                    value = "arn:aws:iam::${local.account_id}:role/cross-account-tf-apply-access"
                },
                {
                    name = "COMMANDS"
                    value = "terragrunt apply-all -auto-approve"
                }
            ]
            order = 2
        }
    ]

}