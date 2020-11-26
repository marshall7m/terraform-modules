resource "aws_codebuild_project" "infrastructure" {
  for_each = {for build in var.builds: build.name => build}
  name          = "${var.resource_prefix}-${each.value.name}-${var.resource_suffix}"
  description   = "Executes the following commands: [${join(", ", each.value.commands)}] within the following target directories: [${join(", ", try(each.value.target_paths, var.target_paths))}]"
  build_timeout = "5"
  service_role  = each.value.service_role_arn

  dynamic "artifacts" {
      for_each = each.value.artifacts
      content {
          type = artifacts.value
      }
  }

  environment {
    compute_type                = try(each.value.build_compute_type, "BUILD_GENERAL1_SMALL")
    image                       = try(each.value.build_image, "aws/codebuild/standard:4.0")
    type                        = try(each.value.build_type, "LINUX_CONTAINER")
    image_pull_credentials_type = try(each.value.image_pull_credentials_type, "CODEBUILD")

    environment_variable {
      name  = "COMMANDS"
      value = join(" && ", each.value.commands)
    }

    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = var.terraform_version
    }

    environment_variable {
      name  = "TERRAGRUNT_VERSION"
      value = var.terragrunt_version
    }

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "true"
    }

    environment_variable {
      name  = "TF_INPUT"
      value = "false"
    }

    dynamic "environment_variable" {
      for_each = each.value.target_paths != null || var.target_paths != null ? [1] : []
      name  = "TARGET_DIRS"
      value = join(" ", try(each.value.target_paths, var.target_paths))
    }

    dynamic "environment_variable" {
        for_each = try(each.value.environment_variables, {}) 
        content {
            name  = environment_variable.key
            value = environment_variable.value
        }
    }
  }
  
  dynamic "logs_config" {
    for_each = try(each.value.s3_log_path, null) != null ? [1] : []
    content {
      s3_logs {
        status   = "ENABLED"
        location = each.value.s3_log_path
      }
    }
  }

  source {
    type            = try(each.value.source_type, var.source_type)
    location        = try(each.value.source_location, null)
    git_clone_depth = try(each.value.git_clone_depth, null)

    buildspec = try(each.value.buildspec, var.buildspec)

  }

    tags = merge(
        var.tags,
        try(each.value.tags, null)
    )
}