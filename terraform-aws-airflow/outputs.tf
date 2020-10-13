output "ec2_role_name" {
    value = "${var.create_airflow_instance ? aws_iam_role.airflow[0].name : null}"
}

output "ec2_id" {
    value = "${var.create_airflow_instance ? aws_instance.airflow[0].id : null}"
}