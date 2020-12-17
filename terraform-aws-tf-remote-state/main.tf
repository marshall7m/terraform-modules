resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket
  
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(var.bucket_tags, var.common_tags)
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.db_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge(var.db_table_tags, var.common_tags)
}