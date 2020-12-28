output "arn" {
    value = {for name,_ in aws_codestarconnections_connection.this: name => aws_codestarconnections_connection.this[name].arn}
}

output "connection_status" {
    value = {for name,_ in aws_codestarconnections_connection.this: name => aws_codestarconnections_connection.this[name].connection_status}
}