resource "aws_codebuild_project" "this" {
  name          = "${var.resource_prefix}-${var.name}-${var.resource_suffix}"
  description   = "Terraform managed codebuild project"
  build_timeout = "5"
  service_role  = coalesce(var.service_role_arn, aws_iam_role.this[0].arn)

  artifacts {
    type = var.artifacts.type
    artifact_identifier = try(var.artifacts.artifact_identifier, null)
    encryption_disabled = try(var.artifacts.encryption_disabled, null)
    override_artifact_name = try(var.artifacts.override_artifact_name, null)
    location = try(var.artifacts.location, null)
    name = try(var.artifacts.name, null)
    namespace_type = try(var.artifacts.namespace_type, null)
    packaging = try(var.artifacts.packaging, null)
    path = try(var.artifacts.path, null)
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = var.build_type
    image_pull_credentials_type = var.build_image_pull_credentials_type

    dynamic "environment_variable" {
        for_each = {for env_var in var.environment_variables: env_var.name => env_var}
        content {
            name  = environment_variable.value.name
            value = environment_variable.value.value
            type = environment_variable.value.type
        }
    }
  }
  
  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
      stream_name = var.cw_stream_name
      group_name = var.cw_group_name
    }
    dynamic "s3_logs" {
      for_each = []
      content {
        status   = "ENABLED"
        location = var.s3_log_path
        encryption_disabled = var.s3_log_encryption_disabled
      }
    } 
  }

  source {
    type            = var.build_source.type
    location        = try(var.build_source.location, null)
    git_clone_depth = try(var.build_source.git_clone_depth, null)
    git_submodules_config = try(var.build_source.git_submodules_config, null)
    insecure_ssl = try(var.build_source.insecure_ssl, null)
    report_build_status =try(var.build_source.report_build_status, null)
    auth = try(var.build_source.auth, null)
    buildspec = try(var.build_source.buildspec, null)
  }
 
    tags = merge(
      var.common_tags, 
      var.build_tags
    )
}

resource "aws_codebuild_webhook" "this" {
  count = var.webhook_filter_groups != null ? 1 : 0
  project_name = aws_codebuild_project.this.name 

  dynamic "filter_group" {
    for_each = var.webhook_filter_groups
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