output "values" {
    value = {for param in var.parameter_keys: param => data.aws_ssm_parameter.this[param].value}
}

