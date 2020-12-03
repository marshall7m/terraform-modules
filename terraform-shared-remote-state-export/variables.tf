variable "shared_data" {
    description = "List of objects to export to the backend"
    type = list(object({
        name = string
        value = any
    }))
}