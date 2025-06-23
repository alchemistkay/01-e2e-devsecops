output "cluster_name" {
  value = module.eks.cluster_name
}

output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "ebs_csi_irsa_role" {
  value = module.ebs_csi_driver.ebs_csi_role_arn
}

output "argocd_server_url" {
  value = module.argocd.server_url
}

output "load_balancer_controller_role" {
  value = module.aws_lbc.lbc_iam_role_arn
}
