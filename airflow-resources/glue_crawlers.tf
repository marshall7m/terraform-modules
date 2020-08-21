resource "aws_iam_role" "glue" {
    path = "/"
    name = "glue"
    description = "Allows ALL Glue Crawlers to call needed AWS services."
    assume_role_policy = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "glue.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    EOF
}
resource "aws_iam_role_policy_attachment" "AWSGlueServiceRole" {
  role = aws_iam_role.glue.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_glue_crawler" "crawlers" {
    for_each = var.glue_crawlers_dict
    name = "${var.env}-${each.key}"
    role = aws_iam_role.glue.arn
    database_name = each.value.data_catalog
    s3_target {
        path = lookup(
            each.value, 
            "s3_target_path",
            "${aws_s3_bucket.base_bucket.id}://${var.service}/${var.env}/data/raw"
        )
    }
    schema_change_policy = each.value.schema_change_policy
    tags = local.tags
}