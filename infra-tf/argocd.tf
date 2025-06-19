resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
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
