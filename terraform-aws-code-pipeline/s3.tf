resource "aws_s3_bucket" "this" {
  count         = var.create_artifact_bucket ? 1 : 0
  bucket        = var.artifact_bucket_name
  acl           = "private"
  force_destroy = var.artifact_bucket_force_destroy
  tags          = merge(var.arifact_bucket_tags, var.common_tags)
}

#### IAM ####

data "aws_iam_policy_document" "s3" {
    count = var.create_artifact_bucket ? 1 : 0
    statement {
        sid = "DenyUnEncryptedObjectUploads"
        effect = "Deny"
        actions = ["s3:PutObject"]
        resources = ["arn:aws:s3:::${var.artifact_bucket_name}/*"]
        principals {
            type        = "*"
            identifiers = ["*"]
        }
        condition {
            test = "StringNotEquals"
            variable = "s3:x-amz-server-side-encryption"
            values = ["aws:kms"]
        }
    }

    statement {
        sid = "DenyInsecureConnections"
        effect = "Deny"
        actions = ["s3:*"]
        resources = ["arn:aws:s3:::${var.artifact_bucket_name}/*"]
        principals {
            type        = "*"
            identifiers = ["*"]
        }
        condition {
            test = "Bool"
            variable = "aws:SecureTransport"
            values = ["false"]
        }
    }

    statement {
        sid = "AllowCrossAccountS3ArtifactReads"
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:Put*"
        ]
        resources = ["arn:aws:s3:::${var.artifact_bucket_name}/*"]
        principals {
            type        = "AWS"
            identifiers = local.trusted_cross_account_arns
        }
    }

    statement {
        sid = "AllowCrossAccountS3ListBucket"
        effect = "Allow"
        actions = ["s3:ListBucket"]
        resources = ["arn:aws:s3:::${var.artifact_bucket_name}"]
        principals {
            type        = "AWS"
            identifiers = local.trusted_cross_account_arns
        }
    }
}

resource "aws_s3_bucket_policy" "this" {
    count = var.create_artifact_bucket ? 1 : 0
    bucket = var.artifact_bucket_name
    policy = data.aws_iam_policy_document.s3[0].json   
}