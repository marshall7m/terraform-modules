output "build_arn" {
    value = aws_codebuild_project.this.arn
}

output "build_name" {
    value = aws_codebuild_project.this.name
}

output "role_arn" {
    value = aws_iam_role.this[0].arn
} 