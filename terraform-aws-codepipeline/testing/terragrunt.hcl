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
    pipeline_name = "test-pipeline"
    account_id = local.account_id
    artifact_bucket_name = "private-demo-org-123-test"
    stages = [
        {
            name = "source-repos"
            actions = [
                {
                    name             = "source-repo"
                    category         = "Source"
                    owner            = "ThirdParty"
                    provider         = "GitHub"
                    version          = "1"
                    output_artifacts = ["source_output"]

                    configuration = {
                        Owner      = "my-organization"
                        Repo       = "test"
                        Branch     = "master"
                        OAuthToken = "test"
                    }
                }
            ]
        },
        {
            name = "dev-infrastructure"
            actions = [
                {
                    name             = "tf-validate"
                    category         = "Test"
                    owner            = "AWS"
                    provider         = "CodeBuild"
                    version          = "1"
                    input_artifacts = ["source_output_two"]
                    output_artifacts = ["dev-tf-validate_output"]
                    role_arn = "arn:aws:iam::${local.account_id}:role/test-role"
                    configuration = {
                        ProjectName = "tf-build"
                        EnvironmentVariables = tostring(jsonencode([
                            {
                                name = "TARGET_DIR"
                                value = ["dev-account/us-west-2"]
                                type = "PLAINTEXT"
                            },
                            {
                                name = "COMMAND"
                                value = "terragrunt validate-all"
                                type = "PLAINTEXT"
                            }
                        ]))
                    }
                }
            ]
        }
    ]
}