output "shared_data" {
    value = {for state in var.remote_states: state.name => data.terraform_remote_state.this[state.name].outputs}
}