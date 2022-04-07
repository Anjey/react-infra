locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
  env_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment = local.env_vars.locals.environment
}

terraform {
  source = "../../../../../modules//s3-bucket"
}

include {
  path = find_in_parent_folders()
}



inputs = {
  environment          = local.environment
  domain_name          = "www.react-project-adudych.romexsoft.net"
  domain_name_redirect = "react-project-adudych.romexsoft.net"
}
