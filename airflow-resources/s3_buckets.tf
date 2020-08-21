resource "aws_s3_bucket" "base_bucket" {
  bucket = var.s3_buckets_dict.base_bucket.name
  acl = var.s3_buckets_dict.base_bucket.acl
}

# resource "aws_s3_bucket" "buckets" {
#   for_each = var.s3_buckets_dict.buckets
#   bucket = each.key
#   acl = each.value.acl
# }

