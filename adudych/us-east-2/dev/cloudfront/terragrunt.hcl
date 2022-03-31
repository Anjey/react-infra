locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
  env_vars    = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment = local.env_vars.locals.environment
}

terraform {
  source = "../../../../../modules//cloudfront"
}

include {
  path = find_in_parent_folders()
}



inputs = {
  environment             = local.environment
  domain_redirect_enabled = false
  cdn_path_pattern        = ["/data"]
  dns_name                = "react-project"
  domain_name             = "www.react-project.romexsoft.net"
  domain_name_redirect    = "react-project.romexsoft.net"
  ssh_whitelist = {
    "188.163.113.206" = "Dudych Home"
    "194.44.153.62"   = "romexsoft_office"
  }
  lb_deletion_protection = false
}
