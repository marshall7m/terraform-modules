# FEATURE: Allow passing in multiple providers for accessing tf_remote_states from different providers 

data "terraform_remote_state" "this" {
  for_each = {for state in var.remote_states: state.name => state}
  backend = each.value.backend
  config = {
    bucket = each.value.bucket
    key    = each.value.key
    region = each.value.region
  }
}