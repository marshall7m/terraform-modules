resource "aws_codestarconnections_connection" "this" {
  for_each = {for conn in var.connections: conn.name => conn}
  name = each.value.name
  provider_type   = each.value.provider
}