module "infrastructure" {
  source     = "./modules/infrastructure"
  region     = local.region
  local_name = local.name
  tags       = local.tags
}


module "helm" {
    source = "./modules/helm"

  cert_manager_irsa_role_arn  = module.infrastructure.cert_manager_irsa_role_arn
  external_dns_irsa_role_arn  = module.infrastructure.external_dns_irsa_role_arn
}

