locals {
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region        = local.region_vars.locals.aws_region
  env_vars          = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment       = local.env_vars.locals.environment
  account_name_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_name      = local.account_name_vars.locals.account_name
  account_id_vars   = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account_id        = local.account_id_vars.locals.aws_account_id
}

terraform {
  source = "git::git@github.com:Anjey/react-module.git//cloudfront?ref=v0.4"
  # source = "../../../../../modules//cloudfront"
}

include {
  path = find_in_parent_folders()
}



inputs = {
  ami_owner_account_ids   = [local.account_id]
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
