locals {
  # Cross-account AWS account ARNs used for S3 artifact bucket policy
  trusted_cross_account_arns = [for id in var.trusted_cross_account_ids: format("arn:aws:iam::%s:root", id) if id != data.aws_caller_identity.current.id]
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "this" {
  count = var.enabled ? 1 : 0
  bucket        = var.name
  acl           = var.acl
  force_destroy = var.force_destroy
  tags          = var.tags
}

data "aws_iam_policy_document" "this" {
    count = length(local.trusted_cross_account_arns) > 0 ? 1 : 0
    statement {
        sid = "DenyUnEncryptedObjectUploads"
        effect = "Deny"
        actions = ["s3:PutObject"]
        resources = ["arn:aws:s3:::${var.name}/*"]
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
        resources = ["arn:aws:s3:::${var.name}/*"]
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
        resources = ["arn:aws:s3:::${var.name}/*"]
        principals {
            type        = "AWS"
            identifiers = local.trusted_cross_account_arns
        }
    }

    statement {
        sid = "AllowCrossAccountS3ListBucket"
        effect = "Allow"
        actions = ["s3:ListBucket"]
        resources = ["arn:aws:s3:::${var.name}"]
        principals {
            type        = "AWS"
            identifiers = local.trusted_cross_account_arns
        }
    }
}

resource "aws_s3_bucket_policy" "this" {
    count = var.enabled && length(local.trusted_cross_account_arns) > 0 ? 1 : 0
    bucket = var.name
    policy = data.aws_iam_policy_document.this[0].json   
}