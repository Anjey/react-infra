locals {
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region   = local.region_vars.locals.aws_region
  env_vars     = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment  = local.env_vars.locals.environment
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_name = local.account_vars.locals.account_name
}

terraform {
  source = "git::git@github.com:Anjey/react-module.git//cloudfront?ref=v0.3"
  # source = "../../../../../modules//cloudfront"
}

include {
  path = find_in_parent_folders()
}



inputs = {
  environment             = local.environment
  domain_redirect_enabled = false

  cdn_path_pattern     = ["/data", "/api"]
  dns_name             = "react-project"
  redirect_domain_name = "react-project.romexsoft.net" #Not used if domain_redirect_enabled is false
  main_domain_name     = "www.react-project.romexsoft.net"
  ssh_whitelist = {
    "188.163.113.206" = "Dudych Home"
    "194.44.153.62"   = "romexsoft_office"
  }
  # tags = {
  #   Name = local.account_name
  # }
  lb_deletion_protection = false

}
