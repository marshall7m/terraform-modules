resource "aws_organizations_organization" "this" {
    count = var.create_organization ? 1 : 0
    aws_service_access_principals = [
        "cloudtrail.amazonaws.com",
        "config.amazonaws.com",
    ]

    feature_set = "ALL"
}

resource "aws_organizations_policy" "this" {
  for_each = {for policy in var.policies: policy.name => policy.content}
  name = each.key
  content = <<CONTENT
${each.value}
CONTENT
}

locals {
    account_policies = chunklist(flatten([for account in var.child_accounts: try(setproduct([account.name], account.policies), [])]), 2)
}
resource "aws_organizations_policy_attachment" "this" {
  count = length(local.account_policies)
  policy_id = aws_organizations_policy.this[local.account_policies[count.index][1]].id
  target_id = aws_organizations_account.this[local.account_policies[count.index][0]].id
}

resource "aws_organizations_account" "this" {
  for_each = {for account in var.child_accounts: account.name => account}
  name  = each.value.name
  email = each.value.email
  role_name = each.value.role_name
}