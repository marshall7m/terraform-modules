output "admin_role_arn"{
  value = try(aws_iam_role.admin[0].arn, null)
}

output "dev_role_arn"{
  value = try(aws_iam_role.dev[0].arn, null)
}

output "read_role_arn"{
  value = try(aws_iam_role.read[0].arn, null)
}

output "tf_plan_role_arn"{
  value = try(aws_iam_role.tf_plan[0].arn, null)
}

output "tf_apply_role_arn" {
  value = try(aws_iam_role.tf_apply[0].arn, null)
}

output "limited_s3_read_role_arn" {
  value = try(aws_iam_role.limited_s3_read[0].arn, null)
}

output "cd_role_arn" {
  value = try(aws_iam_role.cd[0].arn, null)
}