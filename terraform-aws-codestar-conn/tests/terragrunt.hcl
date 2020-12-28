include {
  path = find_in_parent_folders()
}

terraform {
    source = "../"
}

inputs = {
    connections = [
        {
            name = "foo"
            provider = "GitHub"
        }
    ]
}