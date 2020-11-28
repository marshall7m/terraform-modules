resource "aws_codepipeline" "this" {
  name     = var.name
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store_bucket_name
    type     = "S3"
    region = var.artifact_store_region

    dynamic "encryption_key" {
      for_each = var.s3_kms_key_arn != null ? [1] : []
      content{
        id   = var.s3_kms_key_arn
        type = "KMS"
      }
    }
  }
  
  dynamic "stage" {
      for_each = {for stage in var.stages: stage.name => stage}
      content {
          name = stage.key

          dynamic "action" {
              for_each = {for action in stage.value.actions: action.name => action}
              content {
                name             = action.value.name
                category         = action.value.category
                owner            = action.value.owner
                provider         = action.value.provider
                version          = action.value.version
                output_artifacts = action.value.output_artifacts

                configuration = action.value.configuration
              }
          }
      }
  }
  tags = var.tags
}