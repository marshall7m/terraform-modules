output "code_pipeline_arn" {
    value = aws_codepipeline.this.arn
}

output "code_pipeline_role_arn" {
    value = try(aws_iam_role.this[0].arn, null)
}

output "kms_key_arn" {
    value = var.encrypt_artifacts ? coalesce(var.kms_key_arn, try(aws_kms_key.this[0].arn, null)) : null
}
