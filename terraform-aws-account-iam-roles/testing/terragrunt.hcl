include {
  path = find_in_parent_folders()
}

terraform {
    source = "../"
}

locals {
  account_id = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

inputs = {  
  admin_role_cross_account_arns = ["arn:aws:iam::${local.account_id}:root"]
  custom_admin_role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

  dev_role_cross_account_arns = ["arn:aws:iam::${local.account_id}:root"]
  custom_admin_role_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]

  read_role_cross_account_arns = ["arn:aws:iam::${local.account_id}:root"]
  custom_admin_role_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  
  tf_plan_role_cross_account_arns = ["arn:aws:iam::${local.account_id}:root"]
  tf_plan_allowed_actions = [
    "tag:Get*",
    "s3:List*",
    "s3:Get*"
  ]
  tf_plan_allowed_resources = ["*"]

  tf_apply_role_cross_account_arns = ["arn:aws:iam::${local.account_id}:root"]
  tf_apply_allowed_actions = [
    "s3:*"
  ]
  tf_apply_allowed_resources = ["*"]

  auto_deploy_role_cross_account_arns = ["arn:aws:iam::${local.account_id}:root"]
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
 