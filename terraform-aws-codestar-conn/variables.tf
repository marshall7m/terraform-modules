variable "connections" {
    description = "List of Codestar connections to initiate (must be completed in AWS console: https://console.aws.amazon.com/codesuite/settings/connections)"
    type = list(object({
        name = string
        provider = string
    }))
}