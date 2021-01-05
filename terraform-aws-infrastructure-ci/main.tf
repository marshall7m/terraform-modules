locals {
    base_build_env_vars = [
        {
            name  = "TF_IN_AUTOMATION"
            value = "true"
            type  = "PLAINTEXT"
        },
        {
            name  = "TF_INPUT"
            value = "false"
            type  = "PLAINTEXT"
        }
    ]

    stages = [for stage in var.stages: yamldecode(templatefile("files/stage_preset.yaml", {
        order = stage.order
        name = stage.name
        id = stage.id
        branch = var.branch

        build_name = var.build_name
        plan_role_name = try(stage.plan_role_name, var.plan_role_name)
        apply_role_name = try(stage.apply_role_name, var.apply_role_name)
        
        validate_command = try(stage.validate_command, var.validate_command)
        plan_command = try(stage.plan_command, var.plan_command)
        apply_command = try(stage.apply_command, var.apply_command)
        paths = join(" ", stage.paths)
    }))]

    build_assumable_roles = compact(distinct(flatten(concat(
        [var.apply_role_name, var.plan_role_name], 
        [for stage in var.stages: [try(stage.plan_role_name, ""), try(stage.apply_role_name, "")]]
        ))))
}

module "codestar" {
    source = "github.com/marshall7m/terraform-modules/terraform-aws-codestar-conn"
    connections = [var.codestar_conn]
}

module "codebuild" {
    source = "github.com/marshall7m/terraform-modules/terraform-aws-codebuild"
    name = var.build_name
    cross_account_assumable_roles = local.build_assumable_roles
    environment_variables = local.base_build_env_vars
}

module "cmk" {
    count = var.cmk_arn == null ? 1 : 0
    source = "github.com/marshall7m/terraform-modules/terraform-aws-cmk"
    account_id = var.account_id
    trusted_admin_arns = var.cmk_trusted_admin_arns
    trusted_usage_arns = concat(var.cmk_trusted_usage_arns, module.codebuild.role_arn)
    alias = var.cmk_alias
    tags = var.cmk_tags
}

module "codepipeline" {
    source = "github.com/marshall7m/terraform-modules/terraform-aws-code-pipeline"
    account_id = var.account_id
    create_artifact_bucket = true
    pipeline_name = var.pipeline_name
    kms_key_arn = module.cmk[0].arn
    stages = local.stages
}