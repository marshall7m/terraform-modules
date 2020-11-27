resource "aws_codebuild_project" "infrastructure" {
  for_each = var.builds != null ? {for build in var.builds: build.name => build} : tomap({"" = {}})
  name          = try("${var.resource_prefix}-${each.key}-${var.resource_suffix}", "${var.resource_prefix}-${var.name}-${var.resource_suffix}")
  description   = try("Executes the following commands: [${join(", ", each.value.commands)}] within the following target directories: [${join(", ", try(each.value.target_paths, var.target_paths))}]", "Template build project for terraformed infrastructure")
  build_timeout = "5"
  service_role  = try(each.value.service_role_arn, var.service_role_arn)

  dynamic "artifacts" {
    for_each = try(each.value.artifacts, [var.artifacts])
    content {
      type = artifacts.value.type
      artifact_identifier = try(artifacts.value.artifact_identifier, null)
      encryption_disabled = try(artifacts.value.encryption_disabled, null)
      override_artifact_name = try(artifacts.value.override_artifact_name, null)
      location = try(artifacts.value.location, null)
      name = try(artifacts.value.name, null)
      namespace_type = try(artifacts.value.namespace_type, null)
      packaging = try(artifacts.value.packaging, null)
      path = try(artifacts.value.path, null)
    }
  }

  environment {
    compute_type                = try(each.value.build_compute_type, var.build_compute_type)
    image                       = try(each.value.build_image, var.build_image)
    type                        = try(each.value.build_type, var.build_type)
    image_pull_credentials_type = try(each.value.build_image_pull_credentials_type, var.build_image_pull_credentials_type)

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
      for_each = try(each.value.target_paths, var.target_paths) != null ? [1] : []
      content {
        name  = "TARGET_DIRS"
        value = join(" ", try(each.value.target_paths, var.target_paths))
      }
    }

    dynamic "environment_variable" {
      for_each = try(each.value.commands, var.commands) != null ? [1] : []
      content {
        name  = "COMMANDS"
        value = join(" && ", try(each.value.commands, var.commands))
      }
    }

    dynamic "environment_variable" {
        for_each = {for env_var in try(each.value.environment_variables, var.environment_variables): env_var.name => env_var}
        content {
            name  = environment_variable.value.name
            value = environment_variable.value.value
            type = "PLAINTEXT"
        }
    }
  }
  
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
      stream_name = try(each.value.cw_stream_name, var.cw_stream_name)
      group_name = try(each.value.cw_group_name, var.cw_group_name)
    }
    dynamic "s3_logs" {
      for_each = try(each.value.s3_log_path, var.s3_log_path) != null ? [1] : []
      content {
        status   = "ENABLED"
        location = try(each.value.s3_log_path, var.s3_log_path)
        encryption_disabled = try(each.value.s3_log_encryption_disabled, var.s3_log_encryption_disabled)
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
      var.common_tags, 
      try(each.value.tags, null)
    )
}

resource "aws_codebuild_webhook" "infrastructure" {
  for_each = try({for build in var.builds: build.name => build if build.webhook_filter_groups != null}, toset(var.webhook_filter_groups))
  project_name = aws_codebuild_project.infrastructure[each.key].name

  dynamic "filter_group" {
    for_each = try(each.value.webhook_filter_groups, var.webhook_filter_groups)
    content {
      dynamic "filter" {
        for_each = filter_group.value
        content {
          type = filter.value.type
          pattern = filter.value.pattern
          exclude_matched_pattern = filter.value.exclude_matched_pattern
        }
      }
    }
  }
}