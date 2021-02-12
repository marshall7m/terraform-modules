output "bucket_arn" {
  description = "ARN of the Bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "db_table_arn" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.terraform_locks.name
}