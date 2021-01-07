output "codepipeline_arn" {
    value = try(module.codepipeline[0].arn, null)
}

output "codepipeline_role_arn" {
    value = try(module.codepipeline[0].role_arn, null)
}

output "codebuild_arn" {
    value = try(module.codebuild[0].arn, null)
}

output "codebuild_role_arn" {
    value = try(module.codebuild[0].role_arn, null)
}

output "bucket_arn" {
    value = try(module.s3[0].arn, null)
}

output "codestar_arn" {
    value = try(module.codestar[0].arn, null)
}

output "cmk_arn" {
    value = try(module.codestar[0].arn[var.codestar_conn.name], null)
}