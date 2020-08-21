/* 
resource "aws_kms_key" "test" {
  deletion_window_in_days = 7
  description             = "Athena KMS Key"
} */

resource "aws_athena_database" "sparkify" {
  for_each = var.athena_queries_dict
  name   = each.value.database
  bucket = lookup(each.value, "bucket", aws_s3_bucket.base_bucket.id)
}

resource "aws_athena_workgroup" "workgroup" {
  for_each = var.athena_workgroups_dict
  name = each.key

  configuration {
    enforce_workgroup_configuration = lookup(
      each.value, "enforce_workgroup_configuration", 
      true
    )

    result_configuration {
      output_location = lookup(
        each.value, 
        "output_location", 
        "s3://${aws_s3_bucket.base_bucket.id}/${var.service}/${var.env}/data/query/${each.key}/{hive_year}/{hive_month}/{hive_day}/{query_name}/"
      )
    }
  }

  tags = local.tags
}

resource "aws_athena_named_query" "dynamic_queries" {
  for_each = var.athena_queries_dict
  name = each.key
  query = each.value.query
  database = each.value.database
  workgroup = each.value.workgroup
} 