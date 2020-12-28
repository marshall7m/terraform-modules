variable "groups" {
    type = list(object({
        name = string
        assumable_roles = list(string)
        group_users = list(string)
    }))
}