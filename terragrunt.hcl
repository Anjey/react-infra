locals {
  region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region      = local.region_vars.locals.aws_region
  environment_var = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment     = local.environment_var.locals.environment
}

terraform {

  before_hook "before_hook" {
    commands = ["plan", "apply"]
    execute  = ["echo", format("[INFO] Terragrunt running to configure %s environment", upper(local.environment))]
  }
  after_hook "after_hook" {
    commands = ["plan", "apply"]
    execute  = ["echo", format("[INFO] Terragrunt configured %s environment", upper(local.environment))]
  }
}
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "adudych-cloudfront"

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "adudych-cloudfront"
  }
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
region = "${local.aws_region}"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

EOF


}
