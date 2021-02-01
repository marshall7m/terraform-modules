generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-west-2"  
  profile = "sandbox-admin"
}
EOF
}

terraform {
  before_hook "before_hook" {
    commands     = ["init", "validate", "plan", "apply"]
    execute      = ["bash", "-c", "tfenv use min-required || tfenv install min-required && tfenv use min-required"]
  }
}

