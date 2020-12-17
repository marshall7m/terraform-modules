data "aws_ssm_parameter" "this" {
  for_each = toset(var.parameter_keys)
  name = each.value
}

