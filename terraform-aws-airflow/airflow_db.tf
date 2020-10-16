
resource "aws_db_subnet_group" "airflow" {
  count = var.create_airflow_db == true && length(var.private_subnets_ids) > 0 ? 1 : 0
  name        = "${var.resource_prefix}-airflow-db-subnet-group"
  description = "List of subnets ids to be used to host databases stored on AWS RDS"
  subnet_ids  = var.private_subnets_ids
}

resource "aws_db_instance" "airflow" {
  count = var.create_airflow_db == true && var.airflow_db_name != null && var.airflow_db_username != null && var.airflow_db_password != null && var.airflow_db_instance_class != null ? 1 : 0
  identifier                = "${var.resource_prefix}-meta-db"
  allocated_storage         = var.airflow_db_allocated_storage
  engine                    = "postgres"
  engine_version            = "9.6.6"
  instance_class            = var.airflow_db_instance_class
  name                      = var.airflow_db_name
  username                  = var.airflow_db_username
  password                  = var.airflow_db_password
  storage_type              = "gp2"
  backup_retention_period   = 14
  multi_az                  = true
  publicly_accessible       = false
  apply_immediately         = true
  db_subnet_group_name      = aws_db_subnet_group.airflow[count.index].name
  final_snapshot_identifier = "${var.resource_prefix}-meta-db-final-snapshot"
  skip_final_snapshot       = false
  vpc_security_group_ids      = [aws_security_group.airflow[count.index].id]
  port                      = "5432"
}

resource "aws_ssm_parameter" "AIRFLOW__CORE__SQL_ALCHEMY_CONN" {
  count = var.create_airflow_db == true && var.airflow_db_name != null && var.airflow_db_username != null && var.airflow_db_password != null && var.airflow_db_instance_class != null ? 1 : 0
  name  = "${var.resource_prefix}-AIRFLOW__CORE__SQL_ALCHEMY_CONN"
  type  = "SecureString"
  value = aws_db_instance.airflow[count.index].address
  # value = "${var.DB_DRIVER}://${var.aws_db_instance.airflow.username}:${var.aws_db_instance.airflow.password}@${var.aws_db_instance.airflow.address}"
}