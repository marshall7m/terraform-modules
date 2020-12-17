include {
    path = find_in_parent_folders()
}

terraform {
    source = "../"
}

inputs = {
    parameter_keys = ["foo", "bar"]
}
