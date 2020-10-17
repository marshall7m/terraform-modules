output "ec2_role_name" {
    value = "${var.create_airflow_instance ? aws_iam_role.airflow[0].name : null}"
}

output "airflow_ec2_id" {
    value = "${var.create_airflow_instance ? aws_instance.airflow[0].id : null}"
}

output "airflow_db_id" {
    value = "${var.create_airflow_db ? aws_db_instance.airflow[0].id : null}"
}

output "airflow_db_conn_name" {
    description = "Airflow meta-db connection string KEY name (not sensitive) in SSM parameter store."
    value = aws_ssm_parameter.AIRFLOW__CORE__SQL_ALCHEMY_CONN.name
}