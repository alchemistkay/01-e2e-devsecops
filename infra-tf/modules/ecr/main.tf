module "repos" {
  source           = "../ecr-repos"
  repository_names = var.repository_names
}

module "access" {
  source                = "../ecr-access"
  namespace             = var.namespace
  service_account_name  = var.service_account_name
  oidc_provider         = var.oidc_provider
  oidc_provider_arn     = var.oidc_provider_arn
  name_prefix           = var.name_prefix
}
