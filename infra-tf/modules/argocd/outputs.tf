output "argocd_server_url" {
  value = "https://argocd.${var.namespace}.svc.cluster.local"
}
