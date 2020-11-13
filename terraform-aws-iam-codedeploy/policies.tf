data "aws_iam_policy_document" "default_trust_policy" {
  statement {
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["codedeploy.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "code_deploy_role" {
  count = var.create_role && var.attach_aws_code_deploy_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy.name
}


data "aws_iam_policy_document" "s3_access" {
  count = var.create_role && var.attach_s3_access && var.s3_resource_arns != null ? 1 : 0
  statement {
      effect = "Allow"
      resource = var.s3_resource_arns
      actions = [
        "s3:PutObject",
        "s3:GetObject*"
      ]
  }
}

resource "aws_iam_policy" "s3_access" {
  count = var.create_role && var.attach_s3_access && var.s3_resource_arns != null ? 1 : 0 
  name        = "CodeDeploy-Appspec-S3-Access"
  path        = "/"
  description = "Allows CodeDeploy appspec.yml to access have access to necessary AWS services associated with project"
  policy = aws_iam_policy_document.s3_access[0].json
}

data "aws_iam_policy_document" "ssm_access" {
  count = var.create_role && var.attach_ssm_access && var.ssm_resource_arns != null ? 1 : 0
  statement {
      effect = "Allow"
      resource = var.ssm_resource_arns
      actions = [
        "ssm:DescribeParameters",
        "ssm:GetParameters"
      ]
  }

  dynamic "statement" {
      count = length(var.kms_resource_arns)
      content = {
        effect = "Allow"
        resource = statement.kms_resource_arns[count.index]
        actions = ["kms:Decrypt"]
      }
  }
}

resource "aws_iam_policy" "ssm_access" {
  count = var.create_role && var.attach_ssm_access && var.ssm_resource_arns ? 1 : 0
  name        = "${var.role_name}-ssm-access"
  description = var.kms_resource_arns != [] ? "Allows \"${var.role_name}\" role to decrypt and read associated SSM Parameter values" : "Allows \"${var.role_name}\" role to read associated SSM Parameter values"
  policy = aws_iam_policy_document.ssm_access.json
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  policy_arn = aws_iam_policy.ssm_access.arn
  role       = aws_iam_role.code_deploy.name
}


resource "aws_iam_role_policy_attachment" "custom" {
  count = var.create_role ? length(var.custom_role_policy_arns) : 0

  role       = aws_iam_role.codedeploy[0].name
  policy_arn = element(var.custom_role_policy_arns, count.index)
}