locals {
    build_stages = [for stage in var.stages: yamldecode(templatefile("files/build_preset.yaml", {
        order = stage.order == 1 ? stage.order + 1 : stage.order
        stage_name = stage.name
        branch = var.branch
        build_name = var.build_name
        validate_env_vars = jsonencode([for env_var in stage.validate_env_vars: defaults(env_var, {type = "PLAINTEXT"})])
        plan_env_vars = jsonencode([for env_var in stage.plan_env_vars: defaults(env_var, {type = "PLAINTEXT"})])
        apply_env_vars = jsonencode([for env_var in stage.apply_env_vars: defaults(env_var, {type = "PLAINTEXT"})])
    }))]

    source_stage = yamldecode(templatefile("files/source_preset.yaml", {
        stage_name = split("/", var.repo_id)[1]
        branch = var.branch
        connection_arn = var.enabled ? module.codestar[0].arn[var.codestar_conn.name] : ""
        repo_id = var.repo_id
    }))

    stages = concat(local.source_stage, local.build_stages)
}

resource "random_integer" "artifact_bucket" {
  count = var.enabled ? 1 : 0
  min = 10000000
  max = 99999999
  seed = 1
}

module "s3" {
    count = var.enabled ? 1 : 0
    source = "github.com/marshall7m/terraform-modules/terraform-aws-s3"
    name = coalesce(var.artifact_bucket_name, "${var.pipeline_name}-${random_integer.artifact_bucket[0].result}")
}

module "codestar" {
    count = var.enabled ? 1 : 0
    source = "github.com/marshall7m/terraform-modules/terraform-aws-codestar-conn"
    connections = [var.codestar_conn]
}

module "codebuild" {
    count = var.enabled ? 1 : 0
    source = "github.com/marshall7m/terraform-modules/terraform-aws-codebuild"
    name = var.build_name
    assumable_role_arns = var.build_assumable_role_arns
    environment_variables = [for env_var in var.build_env_vars: defaults(env_var, {type = "PLAINTEXT"})]
    artifacts = {
        type = "CODEPIPELINE"
    }
    build_source = {
        type = "CODEPIPELINE"
        buildspec = var.buildspec
    }
}

module "cmk" {
    count = var.enabled && var.cmk_arn == null ? 1 : 0
    source = "github.com/marshall7m/terraform-modules/terraform-aws-cmk"
    account_id = var.account_id
    trusted_admin_arns = var.cmk_trusted_admin_arns
    trusted_usage_arns = concat(var.cmk_trusted_usage_arns, [module.codebuild[0].role_arn])
    alias = var.cmk_alias
    tags = var.cmk_tags
}

module "codepipeline" {
    count = var.enabled ? 1 : 0
    source = "github.com/marshall7m/terraform-modules/terraform-aws-codepipeline"
    account_id = var.account_id
    name = var.pipeline_name
    cmk_arn = module.cmk[0].arn
    artifact_bucket_name = coalesce(var.artifact_bucket_name, "${var.pipeline_name}-${random_integer.artifact_bucket[0].result}")
    stages = local.stages
}