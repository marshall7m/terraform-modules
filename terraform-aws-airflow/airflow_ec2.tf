data "aws_ssm_document" "code_deploy_agent" {
  count = var.install_code_deploy_agent ? 1 : 0
  name            = "AWS-ConfigureAWSPackage"
  document_format = "JSON"
}

data "aws_ssm_document" "ssm_agent" {
  count = var.airflow_ec2_has_ssm_access ? 1 : 0
  name            = "AWS-UpdateSSMAgent"
  document_format = "JSON"
}

resource "aws_ssm_association" "code_deploy_agent" {
  count = var.install_code_deploy_agent ? 1 : 0
  name          = data.aws_ssm_document.code_deploy_agent[0].name
  association_name = "${var.resource_prefix}-airflow-code-deploy-agent-${var.resource_suffix}"
  parameters = {
    action = "Install"
    name = "AWSCodeDeployAgent"
  }
  targets {
    key    = "InstanceIds"
    values = [for instance in aws_instance.airflow: instance.id]
  }
  output_location {
    s3_bucket_name = var.ssm_logs_bucket_name
    s3_key_prefix = var.code_deploy_agent_output_key
  }
}

resource "aws_ssm_association" "ssm_agent" {
  count = var.airflow_ec2_has_ssm_access ? 1 : 0
  name          = data.aws_ssm_document.ssm_agent[0].name
  association_name = "${var.resource_prefix}-airflow-ssm-agent-${var.resource_suffix}"

  targets {
    key    = "InstanceIds"
    values = [for instance in aws_instance.airflow: instance.id]
  }
  output_location {
    s3_bucket_name = var.ssm_logs_bucket_name
    s3_key_prefix = var.ssm_agent_output_key
  }
}

data "aws_ssm_document" "dependencies" {
  name            = "AWS-RunShellScript"
  document_format = "JSON"
}

data "template_file" "dependencies" {
  template = file("${path.module}/ec2_install_dependencies.sh")
  vars = {
    region = var.region
    ecr_repo_url = var.ecr_repo_url
  }
}

resource "aws_ssm_association" "dependencies" {
  name          = data.aws_ssm_document.dependencies.name
  association_name = "${var.resource_prefix}-airflow-dependencies-${var.resource_suffix}"
  parameters = {
    commands = data.template_file.dependencies.rendered
  }
  targets {
    key    = "InstanceIds"
    values = [aws_instance.airflow[0].id]
  }
  output_location {
    s3_bucket_name = var.ssm_logs_bucket_name
    s3_key_prefix = var.ssm_install_dependencies_output_key
  }
}

resource "aws_eip" "airflow" {
  count = var.create_ec2_eip ? 1 : 0
  vpc = true
  instance                  = aws_instance.airflow[0].id
  associate_with_private_ip = aws_instance.airflow[0].private_ip
  tags = merge(
    {
      "Name" = "${var.resource_prefix}-airflow-ec2-eip-${var.resource_suffix}"
    },
    var.common_tags
  )
}

resource "aws_instance" "airflow" {
  count = var.create_airflow_ec2 == true ? 1 : 0
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.airflow[count.index].name
  ami                         = var.airflow_ec2_ami
  instance_type               = var.airflow_ec2_type
  subnet_id                   = coalesce(var.airflow_ec2_subnet_id, var.private_subnet_ids[0])
  vpc_security_group_ids      = [aws_security_group.airflow[count.index].id]
  key_name = var.airflow_ec2_key_name
  
  root_block_device {
    volume_size = 32
  }

  user_data = var.airflow_ec2_user_data

  tags = merge(
    {
      "Name" = "${var.resource_prefix}-airflow-${var.resource_suffix}"
    },
    var.common_tags
  )
}
 
resource "aws_security_group" "airflow" {
  count = var.create_airflow_ec2_sg == true ? 1 : 0
  name        = "${var.resource_prefix}-airflow-${var.resource_suffix}"
  description = "Default security group for airflow instance and postgres meta-db"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.airflow_db_port
    to_port     = var.airflow_db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr_blocks
  }

  egress {
    from_port   = var.airflow_db_port
    to_port     = var.airflow_db_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.airflow_ec2_ssh_cidr_blocks != [] && var.airflow_ec2_key_name != null ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.airflow_ec2_ssh_cidr_blocks
    } 
  } 

  dynamic "egress" {
    for_each = var.airflow_ec2_ssh_cidr_blocks != [] && var.airflow_ec2_key_name != null ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.airflow_ec2_ssh_cidr_blocks
    } 
  }

  dynamic "egress" {
    for_each = var.vpc_s3_endpoint_pl_id != null ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      prefix_list_ids = [var.vpc_s3_endpoint_pl_id]
    } 
  }
}



