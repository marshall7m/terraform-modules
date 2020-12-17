include {
    path = find_in_parent_folders()
}

terraform {
    source = "../"
}

inputs = {
    bucket = "test-123456789012"
    bucket_tags = {
        foo = "bar"
    }
    db_table = "tf_lock"
    db_table_tags = {
        foo = "bar"
    }
}
