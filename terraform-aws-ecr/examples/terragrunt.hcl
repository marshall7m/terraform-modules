include {
  path = find_in_parent_folders()
}

terraform {
    source = "../"
}

inputs = {
    create_repo = true
    ecr_repo_url_to_ssm = true
    name = "data-pipelines"
    ssm_key = "test-key"
}