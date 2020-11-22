data "aws_ssm_parameter" "airflow_db_username" {
  count = var.airflow_db_username_ssm_key != null ? 1 : 0
  name = var.airflow_db_username_ssm_key
}

data "aws_ssm_parameter" "airflow_db_password" {
  count = var.airflow_db_password_ssm_key != null ? 1 : 0
  name = var.airflow_db_password_ssm_key
}

resource "aws_db_subnet_group" "airflow" {
  count = var.create_airflow_db == true && length(var.private_subnet_ids) > 0 ? 1 : 0
  name        = "${var.resource_prefix}-airflow-db-${var.resource_suffix}"
  description = "List of subnets ids to be used to host databases stored on Airflow AWS RDS"
  subnet_ids  = var.private_subnet_ids
}

resource "aws_db_instance" "airflow" {
  count = var.create_airflow_db == true ? 1 : 0
  identifier                = "${var.resource_prefix}-airflow-db-${var.resource_suffix}"
  allocated_storage         = var.airflow_db_allocated_storage
  engine                    = var.airflow_db_engine
  engine_version            = var.airflow_db_engine_version
  instance_class            = var.airflow_db_instance_class
  name                      = var.airflow_db_name
  username                  = coalesce(var.airflow_db_username, try(data.aws_ssm_parameter.airflow_db_username[0].value, null))
  password                  = coalesce(var.airflow_db_password, try(data.aws_ssm_parameter.airflow_db_password[0].value, null))
  storage_type              = var.airflow_db_storage_type
  backup_retention_period   = 14
  multi_az                  = false
  publicly_accessible       = false
  apply_immediately         = true
  db_subnet_group_name      = aws_db_subnet_group.airflow[count.index].name
  final_snapshot_identifier = "${var.resource_prefix}-airflow-db-${var.resource_suffix}"
  skip_final_snapshot       = false
  vpc_security_group_ids      = [aws_security_group.airflow[count.index].id]
  port                      = var.airflow_db_port
}

resource "aws_ssm_parameter" "airflow_db_uri" {
  count = var.create_airflow_db == true && var.load_airflow_db_uri_to_ssm ? 1 : 0
  name  = "${var.resource_prefix}-airflow-db-uri-${var.resource_suffix}"
  type  = "SecureString"
  key_id    = var.airflow_db_uri_ssm_key_alias
  value = "${aws_db_instance.airflow[count.index].engine}://${aws_db_instance.airflow[count.index].username}:${aws_db_instance.airflow[count.index].password}@${aws_db_instance.airflow[count.index].endpoint}"
  tags = merge(var.airflow_db_ssm_tags, var.common_tags)
}