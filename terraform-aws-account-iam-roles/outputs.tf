output "admin_role_arn"{
  value = try(aws_iam_role.admin_role[0].arn, null)
}

output "dev_role_arn"{
  value = try(aws_iam_role.dev_role[0].arn, null)
}

output "read_role_arn"{
  value = try(aws_iam_role.read_role[0].arn, null)
}

output "tf_plan_role_arn"{
  value = try(aws_iam_role.tf_plan_role[0].arn, null)
}

output "tf_apply_role_arn" {
  value = try(aws_iam_role.tf_apply_role[0].arn, null)
}

output "role_arns" {
  value = {
    "admin_access" = try(aws_iam_role.admin_role[0].arn, null)
    "dev_access" = try(aws_iam_role.dev_role[0].arn, null)
    "read_access" = try(aws_iam_role.read_role[0].arn, null)
    "tf_plan" = try(aws_iam_role.tf_plan_role[0].arn, null)
    "tf_apply" = try(aws_iam_role.tf_apply_role[0].arn, null)
  }
}