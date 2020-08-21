resource "aws_glue_job" "jobs" {
  for_each = var.glue_jobs_dict
  name = "${var.env}-${each.key}"
  role_arn = aws_iam_role.glue.arn
  command {
    script_location = lookup(
      each.value, 
      "script_location",
      "${aws_s3_bucket.base_bucket.id}://${var.service}/${var.env}/glue_job_scripts/${each.key}.py"
    )
  }

  default_arguments = {
    output_dir = lookup(
      each.value.default_arguments, 
      "--output_dir",
      "${aws_s3_bucket.base_bucket.id}://${var.service}/${var.env}/data/parquet/{hive_year}/{hive_month}/{hive_day}/"
    )
    catalog_database = lookup(each.value.default_arguments, "--catalog_database", "")
    job-bookmark-option = lookup(each.value.default_arguments, "--job-bookmark-option", "job-bookmark-enable")
  }
  
  tags = local.tags
}
