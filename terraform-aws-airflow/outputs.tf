output "airflow_ec2_role_arn" {
    value = try(aws_iam_role.airflow[0].arn, null)
}

output "airflow_ec2_id" {
    value = try(aws_instance.airflow[0].id, null)
}

output "airflow_ec2_tags" {
    value = try(aws_instance.airflow[0].tags, null)
}

output "airflow_ec2_arn" {
    value = try(aws_instance.airflow[0].arn, null)
}

output "airflow_db_id" {
    value = try(aws_db_instance.airflow[0].id, null)
}

output "airflow_db_arn" {
    value = try(aws_db_instance.airflow[0].arn, null)
}

output "airflow_db_conn_name" {
    description = "Airflow DB URI key in SSM Parameter Store."
    value = try(aws_ssm_parameter.airflow_db_uri[0].name, null)
}

