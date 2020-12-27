include {
  path = find_in_parent_folders()
}

terraform {
    source = "../"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id = local.account_vars.locals.account_id
}

inputs = {  
  admin_role_cross_account_ids = [local.account_id]
  custom_admin_role_policy_ids = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  dev_role_cross_account_ids = [local.account_id]
  custom_admin_role_policy_ids = ["arn:aws:iam::aws:policy/PowerUserAccess"]

  read_role_cross_account_ids = [local.account_id]
  custom_admin_role_policy_ids = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  
  tf_plan_role_cross_account_ids = [local.account_id]
  tf_plan_allowed_actions = [
    "tag:Get*",
    "s3:List*",
    "s3:Get*"
  ]
  tf_plan_allowed_resources = ["*"]

  tf_apply_role_cross_account_ids = [local.account_id]
  tf_apply_allowed_actions = [
    "s3:*"
  ]
  tf_apply_allowed_resources = ["*"]

  auto_deploy_role_cross_account_ids = [local.account_id]
  auto_deploy_statements = [
    {
      effect = "Allow"
      resources = ["*"]
      actions = [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment",
        "codedeploy:GetDeploymentConfig",
        "codedeploy:GetApplicationRevision",
        "codedeploy:RegisterApplicationRevision"
      ]
    },
    {
       effect = "Allow"
       resources = ["*"]
       actions = [
         "s3:GetObject*",
         "s3:PutObject",
         "s3:PutObjectAcl"    
       ]
     }
  ]
}
 