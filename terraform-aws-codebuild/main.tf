resource "aws_codebuild_project" "this" {
  name          = var.name
  description   = var.description
  build_timeout = var.build_timeout
  service_role  = var.role_arn != null ? var.role_arn : try(aws_iam_role.this[0].arn, null)

  artifacts {
    type = var.artifacts.type
    artifact_identifier = var.artifacts.artifact_identifier
    encryption_disabled = var.artifacts.encryption_disabled
    override_artifact_name = var.artifacts.override_artifact_name
    location = var.artifacts.location
    name = var.artifacts.name
    namespace_type = var.artifacts.namespace_type
    packaging = var.artifacts.packaging
    path = var.artifacts.path
  }

  environment {
    compute_type                = var.environment.compute_type
    image                       = var.environment.image
    type                        = var.environment.type
    image_pull_credentials_type = var.environment.image_pull_credentials_type
    privileged_mode = var.environment.privileged_mode
    certificate = var.environment.certificate
    
    dynamic "registry_credential" {
      for_each = var.environment.registry_credential != null ? [1] : []
      content{
        credential = var.environment.registry_credential.credential
        credential_provider = var.environment.registry_credential.credential_provider
      }
    }
    
    dynamic "environment_variable" {
        for_each = var.environment.environment_variables != null ? {for env_var in var.environment.environment_variables: env_var.name => env_var} : {}
        content {
            name  = environment_variable.value.name
            value = environment_variable.value.value
            type = environment_variable.value.type
        }
    }
  }
  
  logs_config {
    dynamic "cloudwatch_logs" {
      for_each = var.cw_logs ? [1] : []
      content {
        status = "ENABLED"
        stream_name = var.cw_stream_name
        group_name = var.cw_group_name
      }
    }
    
    dynamic "s3_logs" {
      for_each = var.s3_logs ? [1] : []
      content {
        status   = "ENABLED"
        location = var.s3_log_path
        encryption_disabled = var.s3_log_encryption_disabled
      }
    } 
  }

  source {
    type            = var.build_source.type
    location        = var.build_source.location
    git_clone_depth = var.build_source.git_clone_depth
    insecure_ssl = var.build_source.insecure_ssl
    report_build_status = var.build_source.report_build_status
    buildspec = var.build_source.buildspec
    
    dynamic "auth" {
      for_each = var.source_token != null || var.source_auth_ssm_param_name != null ? [1] : []
      content {
        type = try(var.build_source.auth.type, "OAUTH")
        resource = try(var.build_source.auth.resource, null)
      }
    }
    dynamic "git_submodules_config" {
      for_each = coalesce(var.build_source.git_submodules_config, {})
      content {
        fetch_submodules = var.build_source.git_submodules_config.fetch_submodules
      }
    }
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

data "aws_ssm_parameter" "this" {
  count = var.source_auth_ssm_param_name != null ? 1 : 0
  name = var.source_auth_ssm_param_name
}

resource "aws_codebuild_source_credential" "this" {
  count = var.source_token != null || var.source_auth_ssm_param_name != null ? 1 : 0
  auth_type   = var.build_source.type == "Bitbucket" ? "BASIC_AUTH" : "PERSONAL_ACCESS_TOKEN"
  user_name   = var.source_user_name
  server_type = var.build_source.type
  token       = try(data.aws_ssm_parameter.this[0].value, var.source_token)
}