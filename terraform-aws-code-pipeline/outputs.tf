output "code_pipeline_arn" {
    value = aws_codepipeline.this.arn
}

output "code_pipeline_role_arn" {
    value = try(aws_iam_role.this[0].arn, null)
}

