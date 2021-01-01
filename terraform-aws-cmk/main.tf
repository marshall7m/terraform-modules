resource "aws_kms_key" "this" {
    count = var.create_key ? 1 : 0
    customer_master_key_spec = var.customer_master_key_spec
    policy = data.aws_iam_policy_document.this.json
    tags = var.tags
}

resource "aws_kms_alias" "this" {
  count = var.create_key && var.alias != null ? 1 : 0
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this[0].key_id
}