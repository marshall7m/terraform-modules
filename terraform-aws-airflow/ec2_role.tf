resource "aws_iam_instance_profile" "airflow" {
  count = var.create_ec2_profile ? 1 : 0
  name = "${var.resource_prefix}-airflow-profile-${var.resource_suffix}"
  role = aws_iam_role.airflow[0].name
}

resource "aws_iam_role" "airflow" {
  count = var.create_ec2_role ? 1 : 0
  name = "${var.resource_prefix}-airflow-ec2-${var.resource_suffix}"
  
  assume_role_policy = data.aws_iam_policy_document.airflow_assume_role[0].json
}

data "aws_iam_policy_document" "airflow_assume_role" {
    count = var.create_ec2_role ? 1 : 0 
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

data "aws_iam_policy_document" "airflow_permissions" {
    count = var.create_ec2_role ? 1 : 0

    statement {
        sid = "ECRReadAccess"
        effect = "Allow"
        actions = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchGetImage",
            "ecr:GetDownloadUrlForLayer"
        ]  
        resources = ["*"]
    }

    dynamic "statement" {
        for_each = var.airflow_ec2_allowed_resources != [] && var.airflow_ec2_allowed_actions != [] ? [1] : []
        content {
            sid = "AllowedPermissions"
            effect = "Allow"
            actions = var.airflow_ec2_allowed_actions
            resources = var.airflow_ec2_allowed_resources
        }
    }
    dynamic "statement" {
        for_each = var.airflow_ec2_role_statements != null ? {for statement in var.airflow_ec2_role_statements: statement.effect => statement} : {}
        content {
            sid = "AllowedPermissions"
            effect = statement.value.effect
            actions = statement.value.actions
            resources = statement.value.resources
            dynamic "condition" {
                for_each = can(statement.value.condition) ? {for condition in statement.value.condition: condition.test => condition} : {}
                content {
                    test = statement.value.condition.test
                    variable = statement.value.condition.variable
                    values = statement.value.condition.values
                }
            }
        }
    }

    dynamic "statement" {
        for_each = var.install_code_deploy_agent ? [1] : []
        content {
            sid = "CodeDeployAgentAccess"
            effect = "Allow"
            actions = ["s3:GetObject"]
            resources = [
                "arn:aws:s3:::aws-codedeploy-${var.region}/*"
            ]
        }
    }

    dynamic "statement" {
        for_each = var.airflow_ec2_has_ssm_access ? [1] : []
        content {
            sid = "SSMS3Access"
            effect = "Allow"
            actions = [
                "s3:GetObject",
                "s3:PutObject"
            ]
            resources = [
                "arn:aws:s3:::${var.ssm_logs_bucket_name}",
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
    }
    dynamic "statement" {
        for_each = var.load_airflow_db_uri_to_ssm ? [1] : []
        content {
            sid = "AirflowDatabaseURIAccess"
            effect = "Allow"
            actions = [
                "ssm:GetParameter",
                "ssm:Decrypt"
            ]
            resources = [aws_ssm_parameter.airflow_db_uri[0].arn]
        }
    }
}

resource "aws_iam_role_policy" "airflow_permissions" {
  count = var.create_ec2_role ? 1 : 0
  role = aws_iam_role.airflow[0].name
  name = "${var.resource_prefix}-airflow-ec2-${var.resource_suffix}"
  policy = data.aws_iam_policy_document.airflow_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "ssm_managed_ec2_core" {
  count = var.create_ec2_role && var.airflow_ec2_has_ssm_access ? 1 : 0
  role       = aws_iam_role.airflow[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

