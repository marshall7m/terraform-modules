output "arn" {
    value = aws_codebuild_project.this.arn
}

output "name" {
    value = aws_codebuild_project.this.name
}

output "role_arn" {
    value = try(aws_iam_role.this[0].arn, null)
}