resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.1.1"
  # values = [
  #   <<EOF
  #       server:
  #       service:
  #           type: LoadBalancer
  #   EOF
  # ]
  depends_on = [module.eks]
}
