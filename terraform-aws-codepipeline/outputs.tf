output "arn" {
    value = aws_codepipeline.this[0].arn
}

output "role_arn" {
    value = try(aws_iam_role.this[0].arn, null)
}