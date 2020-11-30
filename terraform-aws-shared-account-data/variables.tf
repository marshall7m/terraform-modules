variable "remote_states" {
    description = "`terraform_remote_state` data store configurations"
    type = list(object({
        name = string
        backend = string
        bucket = string
        key = string
        region = string
    }))
}