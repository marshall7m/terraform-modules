locals {
  default_airflow_instance_tags = {
    "Name" = "${var.resource_prefix}-airflow-ec2"
    "instance_type" = "${var.airflow_instance_type}"  
    "terraform" = true
  }
  airflow_instance_tags = var.create_airflow_instance == true && var.airflow_instance_tags != {} ? var.airflow_instance_tags : local.default_airflow_instance_tags
}

data "aws_ssm_document" "codedeploy_agent" {
  name            = "AWS-ConfigureAWSPackage"
  document_format = "JSON"
}

data "aws_ssm_document" "ssm_agent" {
  name            = "AWS-UpdateSSMAgent"
  document_format = "JSON"
}

resource "aws_ssm_association" "codedeploy_agent" {
  name          = data.aws_ssm_document.codedeploy_agent.name
  association_name = "${var.resource_prefix}_code_deploy_agent"
  parameters = {
    action = "Install"
    name = "AWSCodeDeployAgent"
  }
  targets {
    key    = "InstanceIds"
    values = [for instance in aws_instance.airflow: instance.id]
  }
  output_location {
    s3_bucket_name = var.private_bucket
    s3_key_prefix = var.ssm_codedeploy_agent_output_key
  }
}

resource "aws_ssm_association" "ssm_agent" {
  name          = data.aws_ssm_document.ssm_agent.name
  association_name = "${var.resource_prefix}_ssm_agent"

  targets {
    key    = "InstanceIds"
    values = [for instance in aws_instance.airflow: instance.id]
  }
  output_location {
    s3_bucket_name = var.private_bucket
    s3_key_prefix = var.ssm_agent_output_key
  }
}

data "aws_ssm_document" "dependencies" {
  name            = "AWS-RunShellScript"
  document_format = "JSON"
}

data "template_file" "install_dependencies" {
  template = "${file("${path.module}/ec2_install_dependencies.sh")}"
  vars = {
    region = var.region
    ecr_repo_url = var.ecr_repo_url
  }
}

resource "aws_ssm_association" "dependencies" {
  name          = data.aws_ssm_document.dependencies.name
  association_name = "${var.resource_prefix}_install_dependencies"
  parameters = {
    commands = data.template_file.install_dependencies.rendered
  }
  targets {
    key    = "InstanceIds"
    values = [for instance in aws_instance.airflow: instance.id]
  }
  output_location {
    s3_bucket_name = var.private_bucket
    s3_key_prefix = var.ssm_install_dependencies_output_key
  }
}

resource "aws_eip" "airflow" {
  vpc = true
  instance                  = aws_instance.airflow[0].id
  associate_with_private_ip = aws_instance.airflow[0].private_ip
  tags = {
    "Name" = "${var.resource_prefix}-airflow-ec2-eip"
  }
}

resource "aws_instance" "airflow" {
  count = var.create_airflow_instance == true && var.airflow_instance_ami != null && var.airflow_instance_type != null && length(var.private_subnets_ids) > 0 ? 1 : 0
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.airflow[count.index].name
  ami                         = var.airflow_instance_ami
  instance_type               = var.airflow_instance_type
  subnet_id                   = var.airflow_instance_subnet_id != null ? var.airflow_instance_subnet_id : var.private_subnets_ids[0]
  vpc_security_group_ids      = [aws_security_group.airflow[count.index].id]
  key_name = var.airflow_instance_key_name
  
  root_block_device {
    volume_size = 32
  }

  user_data = var.airflow_instance_user_data

  tags = local.airflow_instance_tags
}
 
resource "aws_security_group" "airflow" {
  count = var.create_airflow_instance == true && var.create_airflow_instance_sg == true ? 1 : 0
  name        = "${var.resource_prefix}-airflow-ec2-sg"
  description = "Default security group for airflow instance and postgres meta-db"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 5432
    to_port     = 5432
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
    for_each = var.airflow_instance_ssh_cidr_blocks != [] && var.airflow_instance_key_name != null ? [count.index] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.airflow_instance_ssh_cidr_blocks
    } 
  } 

  dynamic "egress" {
    for_each = var.airflow_instance_ssh_cidr_blocks != [] && var.airflow_instance_key_name != null ? [count.index] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.airflow_instance_ssh_cidr_blocks
    } 
  }

  dynamic "egress" {
    for_each = var.vpc_s3_endpoint_pl_id != null ? [count.index] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      prefix_list_ids = [var.vpc_s3_endpoint_pl_id]
    } 
  }
}

resource "aws_iam_role" "airflow" {
  count = var.create_airflow_instance ? 1 : 0
  name = "${var.resource_prefix}-airflow-ec2-role"

  path = "/"
  
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "airflow" {
  count = var.create_airflow_instance ? 1 : 0
  name = "${var.resource_prefix}-airflow-ec2-profile"
  role = aws_iam_role.airflow[count.index].name
}

resource "aws_iam_role_policy" "airflow" {
  count = var.create_airflow_instance && var.airflow_instance_ssm_access ? 1 : 0
  role = aws_iam_role.airflow[count.index].name
  name = "${var.resource_prefix}-airflow-ec2-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
        ],
        "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": [
          "arn:aws:s3:::aws-codedeploy-${var.region}/*",
          "arn:aws:s3:::aws-ssm-${var.region}/*",
          "arn:aws:s3:::aws-windows-downloads-${var.region}/*",
          "arn:aws:s3:::amazon-ssm-${var.region}/*",
          "arn:aws:s3:::amazon-ssm-packages-${var.region}/*",
          "arn:aws:s3:::${var.region}-birdwatcher-prod/*",
          "arn:aws:s3:::aws-ssm-distributor-file-${var.region}/*",
          "arn:aws:s3:::aws-ssm-document-attachments-${var.region}/*",
          "arn:aws:s3:::patch-baseline-snapshot-${var.region}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "airflow_ec2_ssm_bucket_logs" {
  count = var.create_airflow_instance && var.airflow_instance_ssm_access ? 1 : 0
  role = aws_iam_role.airflow[count.index].name
  name = "${var.resource_prefix}-airflow-ec2-s3-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:PutObject"
        ],
        "Resource": "arn:aws:s3:::${var.private_bucket}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  count = var.create_airflow_instance && var.airflow_instance_ssm_access ? 1 : 0
  role       = aws_iam_role.airflow[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

