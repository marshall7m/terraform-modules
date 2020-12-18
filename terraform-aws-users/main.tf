module "aws_users" {
  for_each = { for user in var.users : user.name => user }
  source   = "github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-user?ref=v3.6.0"

  name                          = each.value.name
  create_user                   = try(each.value.create_user, true)
  create_iam_user_login_profile = try(each.value.create_iam_user_login_profile, true)
  create_iam_access_key         = try(each.value.create_iam_access_key, true)
  path                          = try(each.value.path, "/")
  force_destroy                 = try(each.value.force_destroy, false)
  pgp_key                       = try(each.value.pgp_key, "")
  password_reset_required       = try(each.value.password_reset_required, true)
  password_length               = try(each.value.password_length, 20)
  upload_iam_user_ssh_key       = try(each.value.upload_iam_user_ssh_key, false)
  ssh_key_encoding              = try(each.value.ssh_key_encoding, "SSH")
  ssh_public_key                = try(each.value.ssh_public_key, "")
  permissions_boundary          = try(each.value.permissions_boundary, "")
  tags                          = try(each.value.tags, {})
}