output "arn" {
    value = try(aws_kms_key.this[0].arn, null)
}

output "id" {
    value = try(aws_kms_key.this[0].key_id, null)
}