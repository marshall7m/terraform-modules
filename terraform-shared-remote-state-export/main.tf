output "data" {
    value = {for source in var.shared_data: source.name => source}
}