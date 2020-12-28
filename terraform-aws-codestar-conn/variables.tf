variable "connections" {
    description = "List of Codestar connections to initiate (must be completed in AWS console)"
    type = list(object({
        name = string
        provider = string
    }))
}